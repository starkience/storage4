use starknet::ContractAddress;

#[starknet::interface]
pub trait IMultiplication<TContractState> {
    fn store_number1(ref self: TContractState, number1: u64);
    fn store_number2(ref self: TcontractState, number2: u64);
    fn calculate(self: @TContractState) -> u128;
}


#[starknet::contract]
mod Multiplication {
    use starknet::{ContractAddress, get_caller_address, storage_access::StorageBaseAddress};

    #[storage]
    struct Storage {
        number1: LegacyMap::<ContractAddress, u64>,
        mumber2: LegacyMap::<ContractAddress, u64>,
        result: u128
    }
}

#[abi(embed_v0)]
impl Multiplication of super::IMultiplication<ContractState> {
    fn store_number1(ref self: ContractState, number1: u64) {
        let caller = get_caller_address();
        self._store_number1(caller, name);
    }
    
    
    
    fn calculate(self: ContractState) -> u64 {
        (*self.number1) * (*self.number2)
    }
}

#[generate_trait]
impl Private of PrivateTrait {
    fn _store_number1(
        ref self: ContractState, 
        user: ContractAddress,
        number1: u64
    ) {
        // continue here
    }
}



// write calculatio ncontract
// review storage4, where are we writing to the numbers storage?? Take CairoBook contract and replace with number keyword