use task::interfaces::IMySwap::IMySwapDispatcher;
use task::interfaces::IMySwap::IMySwapDispatcherTrait;

#[starknet::component]
pub mod myswap_component {
    use starknet::ContractAddress;

    #[storage]
    struct Storage {
        mySwapAddress : ContractAddress,
    }

    #[embeddable_as(Myswap)]
    impl MySwapImpl<
        TContractState, +HasComponent<TContractState>
    > of super::IMySwap<ComponentState<TContractState>>{
        

    }

    #[generate_trait]
    pub impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {
        fn initializer(ref self: ComponentState<TContractState>, mySwapAddress: ContractAddress) {
            self.mySwapAddress.write(mySwapAddress);
        }

        
    }
}
