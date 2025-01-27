 


 System-Level Invariants:
// Invariant: The sum of all user balances should always equal `totalDeposited`

//  sum(balances[user]) == totalDeposited

// token.balanceOf(address(this)) == totalDeposited

// balances[user] >= 0 && totalDeposited >= 0

// MIN_DEPOSIT_AMOUNT <= depositAmount <= MAX_DEPOSIT_AMOUNT

// withdrawalAmount <= balances[user]

// Interest payments do not affect totalDeposited or user balances.





Function-Level Invariants:
// deposit:

// Pre: MIN_DEPOSIT_AMOUNT <= amount <= MAX_DEPOSIT_AMOUNT

// Post: balances[msg.sender] += amount, totalDeposited += amount, token.balanceOf(address(this)) += amount

// withdraw:

// Pre: amount <= balances[msg.sender], _addr != address(0)

// Post: balances[msg.sender] -= amount, totalDeposited -= amount, token.balanceOf(address(this)) -= amount

// getInterestPerAnnum:

// Pre: block.timestamp >= timestamps[msg.sender] + 365 days, balances[msg.sender] > 0

// Post: token.balanceOf(address(this)) -= interest, balances[msg.sender] and totalDeposited unchanged.

