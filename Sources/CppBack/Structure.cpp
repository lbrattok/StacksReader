#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <exception>

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


Structure::Structure(const std::string& json_str) {
    try {
        json j = json::parse(json_str);

        _tag = j.value("tag", "");
        _type = j.value("type", "");
        _name = j.value("name", "");

        _ref = j.value("reference", "");

        if (j.contains("children") && j["children"].is_array()) {
            for (const auto& json_child : j["children"]) {
                _children.push_back(Structure(json_child.dump()));
            }
        }
    } catch (const std::exception& e) {
        _name = std::string("Error: ") + e.what();
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

std::string Structure::reference() const { return _ref; }

