use starknet::ContractAddress;

#[starknet::interface]
pub trait IOwnership<TContractState> {
    fn transfer_ownership(ref self: TContractState, new_owner: ContractAddress);
    fn owner(self: @TContractState) -> ContractAddress;
}

#[starknet::contract]
mod Ownership {
    use starknet::{ContractAddress, get_caller_address,};

    #[storage]
    struct Storage {
        owner: ContractAddress,
    }


    #[abi(embed_v0)]
    impl Ownership of super::IOwnership<ContractState> {
        fn transfer_ownership(
            ref self: ContractState, // error: Variable was previously moved.
             new_owner: ContractAddress)
        {
            self.only_owner();
           //  let prev_owner = self.owner.read(); // removed for now because we are not emitting events
            self.owner.write(new_owner);
        }

        fn owner(self: @ContractState) -> ContractAddress {
        self.owner.read()
        }

    }


    #[generate_trait]
    impl Private of PrivateTrait {
        fn only_owner(self: ContractState) {
            let caller = get_caller_address();
            assert(caller == self.owner.read(), 'Caller not the owner');
        }
    }
}