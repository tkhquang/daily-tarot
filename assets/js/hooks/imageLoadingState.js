const imageLoadingState = {
  mounted() {
    this.setLoading(!this.el.complete);

    this.el.addEventListener("load", () => {
      this.setLoading(false);
    });
    this.el.addEventListener("error", () => {
      this.setLoading(false);
    });
  },

  setLoading(value) {
    this.el.setAttribute("data-js-loading", value);
    if (!value) {
      this.pushEvent("imageLoadingState.loaded", {
        id: this.el.getAttribute("id"),
      });
    }
  },
};

export default imageLoadingState;
