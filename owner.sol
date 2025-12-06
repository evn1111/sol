pragma solidity ^0.8.0;                               // Требуемая версия компилятора (0.8.0 или выше)

contract Ownable {                                    // Объявление контракта с именем Ownable
    address public owner;                             // Публичная переменная для хранения адреса владельца
    
    modifier onlyOwner() {                            // Определение модификатора доступа только для владельца
        require(msg.sender == owner, "Only owner can call this function"); // Проверка: вызывающий должен быть владельцем
        _;                                            // Место вставки кода функции, к которой применяется модификатор
    }                                                 // Конец модификатора
    
    constructor() {                                   // Конструктор вызывается один раз при развертывании контракта
        owner = msg.sender;                           // Установка владельца как адреса, развернувшего контракт
    }                                                 // Конец конструктора
    
    function ownerFunction() public view onlyOwner returns (string memory) { // Функция доступная только владельцу (только чтение)
        return "This function was called by the owner"; // Возврат строки подтверждения
    }                                                 // Конец функции ownerFunction
    
    function changeOwner(address newOwner) public onlyOwner { // Функция смены владельца (только для текущего владельца)
        require(newOwner != address(0), "New owner cannot be zero address"); // Проверка: новый владелец не нулевой адрес
        owner = newOwner;                            // Обновление переменной владельца
    }                                                 // Конец функции changeOwner
    
    function publicFunction() public pure returns (string memory) { // Публичная функция (доступна всем, не изменяет состояние)
        return "This function can be called by anyone"; // Возврат строки подтверждения
    }                                                 // Конец функции publicFunction
}                                                     // Конец контракта Ownable