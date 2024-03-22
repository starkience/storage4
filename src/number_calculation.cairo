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
        self._store_number1(number1);
    }

    fn store_number2(ref self: ContractState, number2: u64) {
        let caller = get_caller_address();
        self._store_number2(number2);
    }

    fn calculate(self: ContractState, number1: u64, number2: u64) -> u128 {
        let number_1 = self.number1.read(ContractAddress);
        let number_2 = self.number2.read(ContractAddress);
        let result_calc = (*self.number_1) * (*self.number_2);
        self.result.write(result_calc);
        return result_calc;
    }
}

#[generate_trait]
impl Private of PrivateTrait {
    fn _store_number1(ref self: ContractState, user: ContractAddress, number1: u64) {
        self.number1.write(user, number1);
    }

    fn _store_number2(ref self: ContractState, user: ContractAddress, number2: u64) {
        self.number2.write(user, number2);
    }
}
