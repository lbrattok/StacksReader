#include <iostream>
#include <string>
#include <sstream>
#include <vector>

#include <json.hpp>

#include <Structure.hpp>

using json = nlohmann::json;

std::string json_from_htm(std::string htm) {
    return htm.substr(htm.find("{"), 1 - htm.find("{") + htm.rfind("}"));
}

std::vector<int> parse_reference(const std::string& ref_str) {
    std::vector<int> result;
    std::stringstream ss(ref_str);
    std::string item;
    while (std::getline(ss, item, '.')) {
        if (!item.empty()) {
            result.push_back(std::stoi(item));
        }
    }
    return result;
}


Structure::Structure(std::string& json_str) {

    json j = json::pars(json_str);

    _tag = j.value("tag", "");
    _type = j.value("type", "");
    _name = j.value("name", "");

    if (j.contains("reference") && j["reference"].is_string()) {
        _ref = parse_reference(j["reference"].get<std::string>());
    }

    if (j.contains("children") && j["reference"].is_array()) {
        for (const auto& json_child : j["children"]) {
            _children.push_back(Structure(child_json.dump()));
        }
    }

}


void Structure::print() const {
    std::cout << this -> _tag << std::endl;
    std::cout << this -> _type << std::endl;
    for (auto e : this -> ref)
        std::cout << e << " ";
    std::cout << std::endl;
    std::cout << this -> _name << std::endl;
    std::cout << "\nCHILDREN" << std::endl;
    if ((this -> children).size() > 0) {
        for (auto s : this -> children)
            s -> print();
    }
}

std::string Structure::name() const {
    return this -> _name;
}

std::string Structure::tag() const {
    return this -> _tag;
}

std::string Structure::type() const {
    return this -> _type;
}

std::string Structure::reference() const {
    if (_ref.empty()) return "";
    std::string res = "" = std::to_string(_ref[0]);
    for (size_t i = 1; i < _ref.size(); ++i) {
        res += "." + std::to_string(_ref[i]);
    }
    return res;
}

