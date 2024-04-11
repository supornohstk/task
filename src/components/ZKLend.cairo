use task::interfaces::IZKLend::IZKLendDispatcher;
use task::interfaces::IZKLend::IZKLendDispatcherTrait;
use task::interfaces::IERC20::IERC20Dispatcher;
use task::interfaces::IERC20::IERC20DispatcherTrait;


#[starknet::component]
pub mod zklend_component {
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        zkLendAddress : ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Deposit: Deposit,
        Borrow: Borrow,
        Withdraw: Withdraw,
        Repay: Repay,
    }

    #[derive(Drop, starknet::Event)]
    struct Deposit {
        amount: u128,
        token: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct Borrow {
        amount: u128,
        token: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct Withdraw {
        amount: u128,
        token: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct Repay {
        amount: u128,
        token: ContractAddress,
    }

    #[embeddable_as(ZKLend)]
    impl ZKLendImpl<
        TContractState, +HasComponent<TContractState>
    > of super::IZKLend<ComponentState<TContractState>> {

        fn deposit(
            ref self: ComponentState<TContractState>, amount: u128, token: ContractAddress
        ) {
            let _amount: felt252 = amount.into();
            self._deposit(_amount, token);
        }

        fn borrow(
            ref self: ComponentState<TContractState>, amount: u128, token: ContractAddress
        ) {
            let _amount: felt252 = amount.into();
            self._borrow(_amount, token);
        }

        fn withdraw(
            ref self: ComponentState<TContractState>, amount: u128, token: ContractAddress
        ) {
            let _amount: felt252 = amount.into();
            self._withdraw(_amount, token);
        }

        fn repay(
            ref self: ComponentState<TContractState>, amount: u128, token: ContractAddress
        ) {
            let _amount: felt252 = amount.into();
            self._repay(_amount, token);
        }
    }

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {
        fn initializer(ref self: ComponentState<TContractState>, zkLendAddress: ContractAddress) {
            self.zkLendAddress.write(owner);
        }

        fn _deposit(
            ref self: ComponentState<TContractState>, amount: felt252, token: ContractAddress
        ) {
            let zkLendAddress: ContractAddress = self.zkLendAddress.read();
            let zkLend: IZKLendDispatcher = IZKLendDispatcher(zkLendAddress);
            let erc20: IERC20Dispatcher = IERC20Dispatcher(token);
            erc20.approve(zkLendAddress, amount);
            zkLend.deposit(token, amount);
            self.emit(Deposit {amount: amount, token: token});
        }

        fn _borrow(
            ref self: ComponentState<TContractState>, amount: felt252, token: ContractAddress
        ) {
            let zkLendAddress: ContractAddress = self.zkLendAddress.read();
            let zkLend: IZKLendDispatcher = IZKLendDispatcher(zkLendAddress);
            zkLend.borrow(token, amount);
            self.emit(Borrow {amount: amount, token: token});
        }

        fn _withdraw(
            ref self: ComponentState<TContractState>, amount: felt252, token: ContractAddress
        ) {
            let zkLendAddress: ContractAddress = self.zkLendAddress.read();
            let zkLend: IZKLendDispatcher = IZKLendDispatcher(zkLendAddress);
            zkLend.withdraw(token, amount);
            self.emit(Withdraw {amount: amount, token: token});
        }

        fn _repay(
            ref self: ComponentState<TContractState>, amount: felt252, token: ContractAddress
        ) {
            let zkLendAddress: ContractAddress = self.zkLendAddress.read();
            let zkLend: IZKLendDispatcher = IZKLendDispatcher(zkLendAddress);
            let erc20: IERC20Dispatcher = IERC20Dispatcher(token);
            erc20.approve(zkLendAddress, amount);
            zkLend.repay(token, amount);
            self.emit(Repay {amount: amount, token: token});
        }
    }
}
