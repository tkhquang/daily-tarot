// JS Hook for storing some state in sessionStorage or localStorage in the browser.
// The server requests stored data and clears it when requested.
const LocalStateStore = {
  mounted() {
    this.handleEvent("sessionStorage.store", (obj) =>
      this.storeToSessionStorage(obj)
    );
    this.handleEvent("sessionStorage.clear", (obj) =>
      this.clearSessionStorage(obj)
    );
    this.handleEvent("sessionStorage.restore", (obj) =>
      this.restoreFromSessionStorage(obj)
    );

    this.handleEvent("localStorage.store", (obj) =>
      this.storeToLocalStorage(obj)
    );
    this.handleEvent("localStorage.clear", (obj) =>
      this.clearLocalStorage(obj)
    );
    this.handleEvent("localStorage.restore", (obj) =>
      this.restoreFromLocalStorage(obj)
    );
  },

  storeToSessionStorage(obj) {
    sessionStorage.setItem(obj.key, obj.data);
  },

  restoreFromSessionStorage(obj) {
    var data = sessionStorage.getItem(obj.key);
    this.pushEvent(obj.event, data);
  },

  clearSessionStorage(obj) {
    sessionStorage.removeItem(obj.key);
  },

  storeToLocalStorage(obj) {
    localStorage.setItem(obj.key, obj.data);
  },

  restoreFromLocalStorage(obj) {
    var data = localStorage.getItem(obj.key);
    this.pushEvent(obj.event, data);
  },

  clearLocalStorage(obj) {
    localStorage.removeItem(obj.key);
  },
};

export default LocalStateStore;
