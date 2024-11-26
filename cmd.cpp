#include "RadarActionControlMsgBody.hpp"
#include <sstream>
#include <stdexcept>

// Parse the command string
void RadarActionControlMsgBody::parseCommand(const std::string& command) {
    auto tokens = split(command, ';');
    if (tokens.size() != 7) {
        throw std::invalid_argument("Invalid command format. Expected 7 fields.");
    }

    type = std::stoi(tokens[0]);
    id = std::stoi(tokens[1]);
    channels = std::stoi(tokens[2]);
    frequency = std::stod(tokens[3]);
    azimuth = std::stod(tokens[4]);
    elevation = std::stod(tokens[5]);
    mode = std::stoi(tokens[6]);
}

// Print the parsed command
void RadarActionControlMsgBody::printCommand() const {
    std::cout << "Parsed Command:" << std::endl;
    std::cout << "- Type: " << (type == 0 ? "Transmitter" : "Receiver") << std::endl;
    std::cout << "- ID: " << id << std::endl;
    std::cout << "- Channels: " << channels << std::endl;
    std::cout << "- Frequency: " << frequency << " MHz" << std::endl;
    std::cout << "- Azimuth: " << azimuth << " degrees" << std::endl;
    std::cout << "- Elevation: " << elevation << " degrees" << std::endl;
    std::cout << "- Mode: " << mode << std::endl;
}

// Helper function to split a string
std::vector<std::string> RadarActionControlMsgBody::split(const std::string& str, char delimiter) const {
    std::vector<std::string> tokens;
    std::istringstream stream(str);
    std::string token;
    while (std::getline(stream, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}
