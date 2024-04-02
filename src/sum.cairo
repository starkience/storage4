// starknet contract
// fn external fn: get number
// fn external: increment

// store u64
// result = current_value + new-value
// write to storage

// we test if it actually increments

#[starknet::interface]
pub trait ISum<T> {
    fn increment(ref self: T, incr_value: u64) -> u64;
    fn get_sum(self: @T) -> u64;
}

#[starknet::contract]
mod sum {
    #[storage]
    struct Storage {
        sum: u64
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.sum.write(0);
    }


    #[abi(embed_v0)]
    impl Sum of super::ISum<ContractState> {
        fn increment(ref self: ContractState, incr_value: u64) -> u64 {
            let mut n = self.sum.read();
            n += incr_value;
            self.sum.write(n);
            n
        }
        fn get_sum(self: @ContractState) -> u64 {
            self.sum.read()
        }

    }
}

#[cfg(test)]
mod test {
    use storage4::sum::{ISumDispatcherTrait, ISumDispatcher};
    use snforge_std::{ declare, ContractClassTrait, start_prank, CheatTarget };

    #[test]
    fn test_sum() {
        let contract = declare('Sum');
        let contract_address = contract.deploy(@ArrayTrait::new()).unwrap();
        let dispatcher = ISumDispatcher { contract_address };

        let stored_sum = dispatcher.get_sum();
        assert(stored_sum == 0, 'storage not 0');

        start_prank(CheatTarget::One(contract_address), 123.try_into().unwrap());

        dispatcher.increment(100);

        let stored_sum = dispatcher.get_sum();
        assert(stored_sum == 100, 'balance is not 100');
    }
}

    //assert(sum == 0, "Initial storage value not 0");

   // dispatcher.sum(100);

  //let result = sum(incr_value: 42);
// assert_eq!(result == 42, 'No increment');
    // }
// }

// initialize the state

// test self.increment
// self.read
// test

// Partialeq
// include debug trait 

// initialize state
// call fn on this use starknet::increment
// call read
// see if new value is matching 

// test_account.cairo

// starknet::deploy_syscall directly
// or initialize state