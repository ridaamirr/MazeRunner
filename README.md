# Maze Runner

## Project Description

- The game will start when you run your program on DOSBox.
- Clear your screen and place green and red cells on the whole screen at the start of your game, i.e., some of the locations have a red background and some of the locations have a green background.
- Initially, an asterisk '*' (ASCII code 0x2A) will be moving towards the right, i.e., the '*' will start from a starting position (0, 0) and it will keep moving from the first to the last column of the first row until the user changes its direction, making each movement after one second.
- Direction of the '*' can be changed by using Up, Down, Left, or Right arrow keys.
- Downward movement means the '*' will keep moving from the first to the last row of the same column until the user changes its direction. Upward movement means the '*' will keep moving from the last to the first row of the same column until the user changes its direction. Leftward movement means that the '*' will keep moving from the last to the first column of the particular row until the user changes the direction.
- If the '*' crosses a green cell, one point is added to your score, and the cell is cleared (i.e., it becomes black). Display the score on the top right corner of the screen.
- If the '*' hits a red cell, the game is over, and it terminates successfully. Your program will terminate, and DOSBox and command prompt will run normally.

## Implementation Details

- **Language:** Assembly Language (x86)
- **Platform:** DOSBox
- **Tools:** DOS interrupt services for keyboard (9h) and timer (8h)
- **Scoring:** Keep track of the score and display it on the screen.
- **Game Over:** Implement game over conditions when the '*' hits a red cell.

## How to Run

1. Open DOSBox.
2. Load the program.
3. Run the program to start the game.
4. Use arrow keys to change direction and navigate the '*' character.
5. Avoid hitting red cells and try to collect green cells to increase your score.

## License

This project is licensed under the [MIT License](LICENSE).
