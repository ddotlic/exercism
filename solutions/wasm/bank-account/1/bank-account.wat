(module
  
  (global $account_state (mut i32) (i32.const 0)) 
  (global $balance (mut i32) (i32.const 0)) 

  ;;
  ;; Set the state of the bank account to open.
  ;;
  ;; @return {i32} 0 on success, -1 on failure
  ;;
  (func (export "open") (result i32)
    global.get $account_state
    i32.eqz
    if (result i32)
      i32.const 1
      global.set $account_state
      i32.const 0
    else
      i32.const -1
    end
  )

  ;;
  ;; Set the state of the bank account to closed.
  ;;
  ;; @return {i32} 0 on success, -1 on failure
  ;;
  (func (export "close") (result i32)
    global.get $account_state
    i32.const 1
    i32.eq
    if (result i32)
      i32.const 0
      global.set $account_state
      i32.const 0
      global.set $balance
      i32.const 0
    else
      i32.const -1
    end
  )

  ;;
  ;; Deposit the given amount into the bank account.
  ;;
  ;; @param {i32} amount - The amount to deposit
  ;;
  ;; @return {i32} 0 on success, -1 if account closed, -2 if amount negative
  ;;
  (func (export "deposit") (param $amount i32) (result i32)
    global.get $account_state
    i32.eqz
    if
      i32.const -1
      return
    end
    
    local.get $amount
    i32.const 0
    i32.le_s
    if
      i32.const -2
      return
    end
   
    local.get $amount
    global.get $balance
    i32.add
    global.set $balance
    i32.const 0
  )

  ;;
  ;; Withdraw the given amount from the bank account.
  ;;
  ;; @param {i32} amount - The amount to withdraw
  ;;
  ;; @return {i32} 0 on success, -1 if account closed, -2 if amount invalid
  ;;
  (func (export "withdraw") (param $amount i32) (result i32)
    global.get $account_state
    i32.eqz
    if
      i32.const -1
      return
    end

    local.get $amount
    i32.const 0
    i32.le_s
    local.get $amount
    global.get $balance
    i32.gt_s
    i32.or
    if
      i32.const -2
      return
    end
    
    global.get $balance
    local.get $amount
    i32.sub
    global.set $balance

    i32.const 0
  )

  ;;
  ;; Get the current balance of the bank account.
  ;;
  ;; @return {i32} balance on success, -1 if account closed
  ;;
  (func (export "balance") (result i32)
    global.get $account_state
    i32.eqz
    if
      i32.const -1
      return
    end
    global.get $balance
  )
)
