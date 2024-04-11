use starknet::ContractAddress;
#[starknet::interface]
trait IMarket<TContractState> {

    //
    // Permissionless entrypoints
    //

    fn deposit(ref self: TContractState, token: ContractAddress, amount: felt252);

    fn withdraw(ref self: TContractState, token: ContractAddress, amount: felt252);

    fn borrow(ref self: TContractState, token: ContractAddress, amount: felt252);

    fn repay(ref self: TContractState, token: ContractAddress, amount: felt252);

    
}