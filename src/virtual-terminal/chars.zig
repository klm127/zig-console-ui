const std = @import("std");

/// If you want a 1 character comptime string
pub fn AsString(comptime char: u8) *const [1:0]u8 {
    return std.fmt.comptimePrint("{c}", .{char});
}

pub const SmileInvert: u8 = '☺';
pub const Smile: u8 = '☻';
pub const Suit = struct {
    pub const Heart: u8 = '♥';
    pub const Diamond: u8 = '♦';
    pub const Club: u8 = '♣';
    pub const Spade: u8 = '♠';
};
pub const Sex = struct {
    pub const Male: u8 = '♂';
    pub const Female: u8 = '♀';
};
pub const Arrow = struct {
    pub const Thick = struct {
        pub const Right: u8 = '►';
        pub const Left: u8 = '◄';
        pub const Up: u8 = '▲';
        pub const Down: u8 = '▼';
    };
    pub const Thin = struct {
        pub const Up: u8 = '↑';
        pub const Down: u8 = '↓';
        pub const Right: u8 = '→';
    };
    pub const LeftRight: u8 = '↔';
    pub const UpDown: u8 = '↕';
};
pub const Music: u8 = '♫';
pub const Paragraph: u8 = '¶';
pub const Block = struct {
    /// character = ░
    pub const Dark: u8 = 176;
    /// character = ▒
    pub const Medium: u8 = 177;
    /// character = ▓
    pub const Light: u8 = 178;
};

/// If it starts with a capital letter it's the uppercase. Eg, Sigma=Σ and sigma=σ.
pub const Greek = struct {
    pub const alpha: u8 = 'α';
    pub const beta: u8 = 'ß';
    pub const Gamma: u8 = 'Γ';
    pub const Pi: u8 = 'π';
    pub const Sigma: u8 = 'Σ';
    pub const sigma: u8 = 'σ';
    pub const mu: u8 = 'µ';
    pub const tau: u8 = 'τ';
    pub const Phi: u8 = 'Φ';
    pub const phi: u8 = 'φ';
    pub const theta: u8 = 'Θ';
    pub const Omega: u8 = 'Ω';
    pub const delta: u8 = 'δ';
    pub const epsilon: u8 = 'ε';
};

pub const Math = struct {
    pub const Intersection: u8 = '∩';
    pub const Equivalent: u8 = '≡';
    pub const PlusMinus: u8 = '±';
    pub const Ceiling: u8 = '⌠';
    pub const Floor: u8 = '⌡';
    pub const LessThanEqual: u8 = '≤';
    pub const GreaterThanEqual: u8 = '≥';
    pub const Divide: u8 = '÷';
    pub const Approx: u8 = '≈';
    pub const SquareRoot: u8 = '√';
    pub const Raised: u8 = 'ⁿ';
    pub const Squared: u8 = '²';
    pub const Degree: u8 = '°';
    pub const Function: u8 = 'ƒ';
};

pub const Currency = struct {
    pub const Yen: u8 = '¥';
    pub const Points: u8 = '₧';
    pub const Pound: u8 = '£';
    pub const Cents: u8 = '¢';
};

// 217 : ┘         218 : ┌

pub const Border = struct {
    pub const Thin = struct {
        /// character= │
        pub const Vertical: u8 = 179;
        /// character= ┘
        pub const SE: u8 = 217;
        /// character= ┐
        pub const NE: u8 = 191;
        /// character= ┌
        pub const NW: u8 = 218;
        /// character= └
        pub const SW: u8 = 192;
        /// character= ┼
        pub const Cross: u8 = 197;
        /// character= ─
        pub const Horizontal: u8 = 196;
        /// character= ┴
        pub const TUp: u8 = 193;
        /// character= ┬
        pub const TDown: u8 = 194;
        /// character= ├
        pub const TRight: u8 = 195;
        /// character= ┤
        pub const TLeft: u8 = 180;
        /// chars for merging thin to thick borders
        pub const ToThick = struct {
            /// character= ╕
            pub const NE: u8 = 184;
            /// character= ╛
            pub const SE: u8 = 190;
            /// character= ╘
            pub const SW: u8 = 212;
            /// character= ╒
            pub const NW: u8 = 213;
            /// character= ╨
            pub const TUp: u8 = 208;
            /// character= ╡
            pub const TLeft: u8 = 181;
            /// character= ╞
            pub const TRight: u8 = 198;
            /// character= ╥
            pub const TDown: u8 = 210;
            /// character = ╪
            pub const Cross: u8 = 216;
        };
    };
    pub const Thick = struct {
        /// character = ═
        pub const Horizontal: u8 = 205;
        /// character = ║
        pub const Vertical: u8 = 186;
        /// character = ╔
        pub const NW: u8 = 201;
        /// character = ╗
        pub const NE: u8 = 187;
        /// character = ╝
        pub const SE: u8 = 188;
        /// character = ╚
        pub const SW: u8 = 200;
        /// character = ╬
        pub const Cross: u8 = 206;
        /// character = ╣
        pub const TLeft: u8 = 185;
        /// character = ╩
        pub const TUp: u8 = 202;
        /// character = ╦
        pub const TDown: u8 = 203;
        /// character = ╠
        pub const TRight: u8 = 204;
        /// chars for merging thick to thin borders
        pub const ToThin = struct {
            /// character = ╖
            pub const NE: u8 = 183;
            /// character = ╜
            pub const SE: u8 = 189;
            /// character = ╙
            pub const SW: u8 = 211;
            /// character = ╓
            pub const NW: u8 = 214;
            /// character = ╢
            pub const TLeft: u8 = 182;
            /// character = ╟
            pub const TRight: u8 = 199;
            /// character = ╧
            pub const TUp: u8 = 207;
            /// character = ╤
            pub const TDown: u8 = 209;
            /// character = ╫
            pub const Cross: u8 = 215;
        };
    };
};

// test "testchars" {
//     var i: u8 = 0;
//     const cols = 2;
//     while (i < 255) : (i += 1) {
//         std.debug.print("{d} : {c}\t\t", .{ i, i });
//         if (i % cols == 0) {
//             std.debug.print("\n", .{});
//         }
//     }
// }
