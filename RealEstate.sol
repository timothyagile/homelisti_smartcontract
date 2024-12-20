// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstateTransactions {
    // Struct để lưu thông tin của một giao dịch bất động sản
    struct Transaction {
        uint256 transactionId;
        int buyerId;
        int sellerId;
        int propertyId;
        uint256 timestamp;
    }

    // Mapping để lưu trữ giao dịch theo transactionId
    mapping(uint256 => Transaction) private transactions;

    // Biến đếm để tạo ra transactionId tăng dần
    uint256 private currentTransactionId;

    // Sự kiện được phát ra khi một giao dịch mới được ghi lại
    event TransactionRecorded(
        uint256 indexed transactionId,
        int buyerId,
        int sellerId,
        int propertyId,
        uint256 timestamp
    );

    // Hàm khởi tạo contract, thiết lập giá trị ban đầu cho transactionId
    constructor() {
        currentTransactionId = 1; // Bắt đầu từ transactionId = 1
    }

    // Hàm để ghi lại một giao dịch mới và trả về transactionId
    function recordTransaction(int buyerId, int sellerId, int propertyId) external returns (uint256) {
        require(buyerId != 0 && sellerId != 0 && propertyId != 0, "Invalid input values.");

        uint256 transactionId = currentTransactionId;

        // Kiểm tra xem giao dịch đã tồn tại chưa
        require(transactions[transactionId].timestamp == 0, "Transaction ID already exists.");

        // Cập nhật thông tin giao dịch
        transactions[transactionId] = Transaction({
            transactionId: transactionId,
            buyerId: buyerId,
            sellerId: sellerId,
            propertyId: propertyId,
            timestamp: block.timestamp
        });

        // Tăng transactionId cho lần ghi giao dịch tiếp theo
        currentTransactionId++;

        // Phát sự kiện ghi nhận giao dịch
        emit TransactionRecorded(transactionId, buyerId, sellerId, propertyId, block.timestamp);

        // Trả về transactionId vừa tạo
        return transactionId;
    }

    // Hàm để truy xuất thông tin giao dịch theo transactionId
    function getTransaction(uint256 transactionId) external view returns (Transaction memory) {
        require(transactions[transactionId].timestamp != 0, "Transaction ID does not exist.");
        return transactions[transactionId];
    }
}
