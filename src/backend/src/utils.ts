/**
 * Generates a color code that is used for checkin validation
 * @param count count of colors used for the generated color code
 * @returns 
 */
export const generateValidatorCode = (count = 4) => {
  const colors = ["RED", "GREEN", "BLUE", "YELLOW"];

  const picks = [];
  for (let i = 0; i < count; ++i) {
    picks.push(colors[Math.floor(Math.random() * colors.length)]);
  }
  return picks;
};
