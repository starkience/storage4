trait RectangleTrait {
    fn area(self: @Rectangle) -> u64;
}

impl RectangleImpl of RectangleTrait {
    fn area(self: @Rectangle) -> u64 {
        (*self.width) * (*self.hight)
    }
}

fn main() {
    let rect1 = Rectangle { width: 30, height: 50, };
    println!("Area is {}", rect1.area());
}
