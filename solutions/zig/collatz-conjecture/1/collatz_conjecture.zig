pub const ComputationError = error{ IllegalArgument, Overflow };

pub fn steps(number: usize) ComputationError!usize {
    if (number < 1) return ComputationError.IllegalArgument;

    var num_steps: usize = 0;
    var current = number;
    while (current != 1) {
        if (current % 2 == 0) {
            current /= 2;
        } else {
            current = current * 3 + 1;
        }
        const op = @addWithOverflow(num_steps, 1);
        if (op[1] != 0) {
            return ComputationError.Overflow;
        } else num_steps = op[0];
    }
    return num_steps;
}
