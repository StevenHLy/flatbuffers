#include "RadarActionControlMsgBody.hpp"

int main() {
    RadarActionControlMsgBody radarAction;

    // Example command
    std::string command = "0; 2; 2; 1500.5; 45.0; 10.0; 1";

    try {
        radarAction.parseCommand(command);  // Parse the command
        radarAction.printCommand();        // Print the parsed command
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }

    return 0;
}
