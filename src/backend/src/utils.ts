export const generateValidatorCode = (count = 4) => {
  const colors = ["RED", "GREEN", "BLUE", "YELLOW"];

  const picks = [];
  for (let i = 0; i < count; ++i) {
    picks.push(colors[Math.floor(Math.random() * colors.length)]);
  }
  return picks;
};
