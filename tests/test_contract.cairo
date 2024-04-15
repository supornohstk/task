use starknet::ContractAddress;
use snforge_std::{declare, ContractClassTrait, start_prank, CheatTarget, stop_prank};
use task::interfaces::iintegration::IIntegrationContractDisptcher;
use task::interfaces::iintegration::IIntegrationContractDisptcherTrait;
use task::interfaces::ierc20::IERC2020ContractDisptcher;
use task::interfaces::ierc20::IERC2020ContractDisptcherTrait;


fn deploy_contract(name: felt252) -> ContractAddress {
    let contract = declare(name);
    contract.deploy(@ArrayTrait::new()).unwrap()
}

#[test]
fn deposit_test(){
    //inititalizing the contracts, setting up
    let contract_address = deploy_contract('Integration');
    let contract_dispatcher = IIntegrationContractDisptcher { contract_address};
    let usdc_contract_address: ContractAddress = 0x053c91253bc9682c04929ca02ed00b3e423f6710d2ee7e0d5ebb06f3ecf368a8;
    let usdc_dispatcher = IERC2020ContractDisptcher { contract_address: usdc_contract_address};
    //setting up the caller address
    let caller_address: ContractAddress = 123.try_into().unwrap();
    //getting the balance of the caller before the deposit
    let balBefore = usdc_dispatcher.balance_of(caller_address);
    start_prank(CheatTarget::One(contract_address), caller_address);
    //depositing 100 usdc to the contract as the caller
    contract_dispatcher.deposit(100, 0x053c91253bc9682c04929ca02ed00b3e423f6710d2ee7e0d5ebb06f3ecf368a8);
    stop_prank(CheatTarget::One(contract_address));
    //getting the balance of the caller after the deposit
    let balAfter = usdc_dispatcher.balance_of(caller_address);
    assert_eq!(balBefore - 100, balAfter);
    
}
fn withdraw_test(){
    //inititalizing the contracts, setting up
    let contract_address = deploy_contract('Integration');
    let contract_dispatcher = IIntegrationContractDisptcher { contract_address};
    let usdc_contract_address: ContractAddress = 0x053c91253bc9682c04929ca02ed00b3e423f6710d2ee7e0d5ebb06f3ecf368a8;
    let usdc_dispatcher = IERC2020ContractDisptcher { contract_address: usdc_contract_address};
    //setting up the caller address
    let caller_address: ContractAddress = 123.try_into().unwrap();
    // depositing first
    let balBefore = usdc_dispatcher.balance_of(caller_address);
    start_prank(CheatTarget::One(contract_address), caller_address);
    contract_dispatcher.deposit(100, 0x053c91253bc9682c04929ca02ed00b3e423f6710d2ee7e0d5ebb06f3ecf368a8);
    //getting the balance of the caller after the deposit
    let balAfterDeposit = usdc_dispatcher.balance_of(caller_address);
    //withdrawing 100 usdc from the contract as the caller
    contract_dispatcher.withdraw(100, 0x053c91253bc9682c04929ca02ed00b3e423f6710d2ee7e0d5ebb06f3ecf368a8)
    stop_prank(CheatTarget::One(contract_address));
    //getting the balance of the caller after the withdraw
    let balAfterWithdraw = usdc_dispatcher.balance_of(caller_address);  
    assert_eq!(balBefore, balAfterWithdraw);
    assert_lt!(balAfterDeposit, balAfterWithdraw);
}