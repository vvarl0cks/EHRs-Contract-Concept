pragma solidity ^0.8.0;

contract MedicalRecordSystem {

    // Structures for storing patient and medical record data
    struct Patient {
        string name;
        address walletAddress;
    }

    struct MedicalRecord {
        string date;
        string diagnosis;
        string treatmentPlan;
    }

    // Mappings for storing patient and medical record data
    mapping(address => Patient) public patients;
    mapping(address => MedicalRecord[]) public medicalRecords;

    // List of authorized doctors and administrators
    address[] public authorizedUsers;

    // Constructor to initialize the smart contract
    constructor() {
        // Add the contract deployer as an authorized user
        authorizedUsers.push(msg.sender);
    }

    // Modifier to restrict access to authorized users only
    modifier onlyAuthorized() {
        require(isAuthorized(msg.sender), "Only authorized users can access this function");
        _;
    }

    // Function to check if an address is authorized
    function isAuthorized(address userAddress) public view returns (bool) {
        for (uint i = 0; i < authorizedUsers.length; i++) {
            if (authorizedUsers[i] == userAddress) {
                return true;
            }
        }
        return false;
    }

    // Function to register a new patient
    function registerPatient(string memory name, address walletAddress) public onlyAuthorized {
        patients[walletAddress] = Patient(name, walletAddress);
    }

    // Function to add a new medical record for a patient
    function addMedicalRecord(address patientAddress, string memory date, string memory diagnosis, string memory treatmentPlan) public onlyAuthorized {
        MedicalRecord memory medicalRecord = MedicalRecord(date, diagnosis, treatmentPlan);
        medicalRecords[patientAddress].push(medicalRecord);
    }

    // Function to get the medical records for a patient
    function getMedicalRecords(address patientAddress) public view onlyAuthorized returns (MedicalRecord[] memory) {
        return medicalRecords[patientAddress];
    }
}
