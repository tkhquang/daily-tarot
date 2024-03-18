// JS Hook for web console commands
const webConsole = {
  mounted() {
    this.handleEvent("console.log", (arg) => console.log(arg));
    this.handleEvent("console.error", (arg) => console.error(arg));
    this.handleEvent("console.warn", (arg) => console.warn(arg));
  },
};

export default webConsole;
