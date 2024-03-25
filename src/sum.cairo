// starknet contract
// fn external fn: get number
// fn external: increment

// store u32
// result = current_value + new-value
// write to storage

#[starknet::interface]
pub trait ISum<T> {
    fn increment(ref self: T, incr_value: u64) -> u64;
}

#[starknet::contract]
mod sum {
    #[storage]
    struct Storage {
        sum: u64
    }

    #[abi(embed_v0)]
    impl Sum of super::ISum<ContractState> {
        fn increment(ref self: ContractState, incr_value: u64) -> u64{
            let mut n = self.sum.read();
            n += incr_value;
            self.sum.write(n);
            n
        }
    }
}
