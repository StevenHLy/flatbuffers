#include <iostream>
#include <vector>
#include <random>
#include <sstream>
#include <iomanip>

// Structure to store packed data for each iteration
struct PackedData {
    double azimuth;
    double elevation;
    std::vector<double> c1;
    std::vector<double> c2;
    std::vector<double> c3;
};

// Function to generate a random double within a specified range
double generateRandomDouble(double min, double max) {
    static std::random_device rd;
    static std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(min, max);
    return dis(gen);
}

// Function to generate data and pack into PackedData struct
PackedData generatePackedData(int a) {
    PackedData data;

    // Generate azimuth and elevation values
    data.azimuth = generateRandomDouble(0, 360);  // Example range 0 to 360 degrees
    data.elevation = generateRandomDouble(0, 90); // Example range 0 to 90 degrees

    // Generate values for c1, c2, and c3
    data.c1 = {generateRandomDouble(20.0, 22.0), generateRandomDouble(6920.0, 6980.0), static_cast<double>(a), 6950.0};
    data.c2 = {generateRandomDouble(20.0, 22.0), generateRandomDouble(6920.0, 6980.0), static_cast<double>(a), 6950.0};
    data.c3 = {generateRandomDouble(20.0, 22.0), generateRandomDouble(6920.0, 6980.0), static_cast<double>(a), 6950.0};

    return data;
}

// Function to serialize PackedData struct for sending to a simulator
std::string serializePackedData(const PackedData& data) {
    std::ostringstream oss;

    // Serialize azimuth and elevation
    oss << std::fixed << std::setprecision(4) << data.azimuth << " "
        << data.elevation << " ";

    // Serialize c1, c2, and c3 vectors
    for (double val : data.c1) oss << val << " ";
    for (double val : data.c2) oss << val << " ";
    for (double val : data.c3) oss << val << " ";

    return oss.str();
}

// Function to simulate sending packed data to a simulator
void sendToSimulator(const PackedData& data) {
    std::string serializedData = serializePackedData(data);
    std::cout << "Sending to Simulator: " << serializedData << std::endl;
}

int main() {
    // Generate and pack data for 250 iterations
    for (int a = 1; a <= 250; ++a) {
        // Generate packed data for each iteration
        PackedData data = generatePackedData(a);

        // Simulate sending packed data to a simulator
        sendToSimulator(data);
    }

    return 0;
}
