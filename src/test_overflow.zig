fn AddCeil(a: u8, b: u8) u8 {
    const check: i16 = @as(i16, a) + @as(i16, b);
    if (check > 0) {
        return 255;
    }
    return a + b;
}
fn SubCeil(a: u8, b: u8) u8 {
    const check: i16 = @as(i16, a) - @as(i16, b);
    if (check < 0) {
        return 0;
    }
    return a - b;
}

test "overflow" {
    _ = AddCeil(255, 20);
    _ = SubCeil(1, 10);
}
