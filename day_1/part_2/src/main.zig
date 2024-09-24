const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    var arr = std.ArrayList(u8).init(allocator);
    defer arr.deinit();

    var sum: i32 = 0;
    while (true) {
        reader.streamUntilDelimiter(arr.writer(), '\n', null) catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };
        var firstNum: i32 = 0;
        var lastNum: i32 = 0;

        for (arr.items, 0..) |item, i| {
            var num: i32 = switch (item) {
                '1' => 1,
                '2' => 2,
                '3' => 3,
                '4' => 4,
                '5' => 5,
                '6' => 6,
                '7' => 7,
                '8' => 8,
                '9' => 9,
                else => 0,
            };
            if (num == 0) {
                num = if (std.mem.startsWith(u8, arr.items[i..], "one")) 1 else num;
                num = if (std.mem.startsWith(u8, arr.items[i..], "two")) 2 else num;
                num = if (std.mem.startsWith(u8, arr.items[i..], "three")) 3 else num;
                num = if (std.mem.startsWith(u8, arr.items[i..], "four")) 4 else num;
                num = if (std.mem.startsWith(u8, arr.items[i..], "five")) 5 else num;
                num = if (std.mem.startsWith(u8, arr.items[i..], "six")) 6 else num;
                num = if (std.mem.startsWith(u8, arr.items[i..], "seven")) 7 else num;
                num = if (std.mem.startsWith(u8, arr.items[i..], "eight")) 8 else num;
                num = if (std.mem.startsWith(u8, arr.items[i..], "nine")) 9 else num;
            }

            lastNum = if (num == 0) lastNum else num;
            if (firstNum == 0) {
                firstNum = lastNum;
            }
        }

        sum += firstNum * 10 + lastNum;
        arr.clearRetainingCapacity();
    }
    std.debug.print("{d}", .{sum});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
