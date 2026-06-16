#pragma once

#include <string>
#include <vector>

std::string json_from_htm(std::string htm);


class Structure {
    std::string _tag;
    std::string _name;
    std::vector<int> _ref;
    std::string _type;
    std::vector<Structure> _children;

    public:
        Structure() = default;
        Structure(const std::string& json_str);

        void print(int indent = 0) const;
        std::string name() const;
        std::string tag() const;
        std::string reference() const;
        std::string type() const;

        const std::vector<Structure>& children() const { return _children; }
};
