use starknet::ContractAddress;
use task::interfaces::IERC20::IERC20Dispatcher;
use task::interfaces::IERC20::IERC20DispatcherTrait;


#[starknet::contract]

mod Integrations {
    use contracts::components::zklend_component;
    use contracts::components::myswap_component;

    component!(path: zklend_component, storage: zklend, event: zklendEvent);
    component!(path: myswap_component, storage: myswap, event: myswapEvent);

    #[abi(embed_v0)]
    impl ZKLendImpl = zklend_component::ZKlend<ContractState>;
    impl ZKLendInternalImpl = zklend_component::InternalImpl<ContractState>;

    impl MySwapImpl = myswap_component::MySwap<ContractState>;
    impl MySwapInternalImpl = myswap_component::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        usdcAddress: ContractAddress,
        usdtAddress: ContractAddress,
        #[substorage(v0)]
        zklend: zklend_component::Storage,
        myswap: myswap_component::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        ZKLendEvent: zklend_component::Event,
        MySwapEvent: myswap_component::Event,
    }

    #[constructor]
    fn constructor( ref self: ContractState, mySwapAddress: ContractAddress, zkLendAddress: ContractAddress) {
        self.initializer(zkLendAddress, mySwapAddress);
    }

    #[abi(embed_v0)]
    fn deposit(ref self:ContractState, amount: u128, token: ContractAddress) {
        self._deposit(amount, token);
    }

    fn withdraw(ref self:ContractState, amount: u128, token: ContractAddress) {
        self._withdraw(amount, token);
    }


    #[generate_trait]
    impl InternalImpl of InternalFunctionsTrait{
        fn _deposit(ref self:ContractState, amount: u128, token: ContractAddress){
            self.zklend.deposit(amount, token);
            let usdcAddress = self.usdcAddress.read();
            let usdtAddress = self.usdtAddress.read();
            self.zklend.borrow(amount, usdcAddress);
            //myswap code




        }

        fn _withdraw(ref self:ContractState, amount: u128, token: ContractAddress){
            //myswap code
            self.zklend.repay(amount, token);
            self.zklend.withdraw(amount, token);
        }
    }


}