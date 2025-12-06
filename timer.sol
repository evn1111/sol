pragma solidity ^0.8.0;                               // Минимальная версия компилятора 0.8.0

contract TimedAction {                                // Объявление контракта с таймером
    uint256 private timerEnd;                         // Приватная переменная для времени окончания таймера
    bool private actionExecuted;                      // Приватный флаг выполнения действия
    
    event TimerStarted(uint256 endTime, uint256 duration); // Событие при запуске таймера
    event ActionExecuted(address executor, uint256 timestamp); // Событие при выполнении действия
    
    function startTimer(uint256 secondsToWait) public { // Функция запуска таймера с заданной длительностью
        require(timerEnd == 0 || block.timestamp >= timerEnd, "Timer already running"); // Проверка: таймер не должен быть активен
        require(secondsToWait > 0, "Duration must be positive"); // Проверка: длительность должна быть положительной
        
        timerEnd = block.timestamp + secondsToWait;   // Расчет времени окончания (текущее время + длительность)
        actionExecuted = false;                       // Сброс флага выполнения действия
        
        emit TimerStarted(timerEnd, secondsToWait);   // Генерация события о запуске таймера
    }                                                 // Конец функции startTimer
    
    function isTimerExpired() public view returns (bool) { // Функция проверки истечения таймера (только чтение)
        if (timerEnd == 0) return false;              // Если таймер не установлен - возврат false
        return block.timestamp >= timerEnd;           // Возврат true если текущее время >= времени окончания
    }                                                 // Конец функции isTimerExpired
    
    function executeAction() public {                 // Функция выполнения защищенного действия
        require(timerEnd > 0, "Timer not started");   // Проверка: таймер должен быть запущен
        require(block.timestamp >= timerEnd, "Timer not expired"); // Проверка: таймер должен истечь
        require(!actionExecuted, "Action already executed"); // Проверка: действие не должно быть выполнено ранее
        
        actionExecuted = true;                        // Установка флага выполнения действия
        
        emit ActionExecuted(msg.sender, block.timestamp); // Генерация события о выполнении действия
    }                                                 // Конец функции executeAction
    
    function getTimerEnd() public view returns (uint256) { // Геттер для получения времени окончания таймера
        return timerEnd;                              // Возврат значения приватной переменной timerEnd
    }                                                 // Конец функции getTimerEnd
    
    function getRemainingTime() public view returns (int256) { // Функция получения оставшегося времени
        if (timerEnd == 0 || block.timestamp >= timerEnd) return 0; // Если таймер не установлен или истек - возврат 0
        return int256(timerEnd) - int256(block.timestamp); // Расчет разницы (окончание - текущее время)
    }                                                 // Конец функции getRemainingTime
    
    function resetTimer() public {                    // Функция сброса таймера
        require(timerEnd > 0 && block.timestamp >= timerEnd, "Can only reset after expiry"); // Проверка: сброс только после истечения
        timerEnd = 0;                                 // Обнуление времени окончания
        actionExecuted = false;                       // Сброс флага выполнения действия
    }                                                 // Конец функции resetTimer
}                                                     // Конец контракта TimedAction