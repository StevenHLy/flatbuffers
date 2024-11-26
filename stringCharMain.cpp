#include "RadarActionControlMsgBody.hpp"
#include <iostream>

int main() {
    RadarActionControlMsgBody radarAction;

    // Example command string with mixed data types
    std::string command = "123 ; hello ; 456 ; world";

    // Set the command and parse it
    radarAction.setCommand(command);

    // Print the parsed command arguments
    radarAction.printCommandArguments();

    // Access individual arguments
    const auto& arguments = radarAction.getCommandArguments();
    for (size_t i = 0; i < arguments.size(); ++i) {
        std::cout << "Argument " << i + 1 << ": ";
        std::visit([](const auto& value) {
            std::cout << value << std::endl;
        }, arguments[i]);
    }

    return 0;
}
