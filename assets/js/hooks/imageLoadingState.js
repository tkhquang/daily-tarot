const imageLoadingState = {
  mounted() {
    const image = this.el;
    const id = image.getAttribute("id");
    const skeleton = document.getElementById(`skeleton-${id}`);
    const placeholder = document.getElementById(`placeholder-${id}`);

    this.setImageLoadingState(!image.complete);

    image.addEventListener("load", () => {
      this.setImageLoadingState(false);
    });
    image.addEventListener("error", () => {
      this.setImageErrorState();
    });
    placeholder?.addEventListener("load", () => {
      skeleton?.setAttribute("data-js-image-loading", false);
    });
    placeholder?.addEventListener("error", () => {
      // Handle error state later
    });
  },

  setImageLoadingState(value) {
    const image = this.el;
    const id = image.getAttribute("id");
    const skeleton = document.getElementById(`skeleton-${id}`);
    const placeholder = document.getElementById(`placeholder-${id}`);
    const error = document.getElementById(`error-${id}`);

    image.setAttribute("data-js-loading", value);
    skeleton?.setAttribute("data-js-image-loading", value);
    placeholder?.setAttribute("data-js-image-loading", value);
    error?.setAttribute("data-js-image-loading", value);

    if (image.getAttribute("data-js-image-error") === "true") {
      image.removeAttribute("data-js-image-error");
    }

    if (skeleton?.getAttribute("data-js-image-error") === "true") {
      skeleton.removeAttribute("data-js-image-error");
    }

    if (placeholder?.getAttribute("data-js-image-error") === "true") {
      placeholder.removeAttribute("data-js-image-error");
    }

    if (error?.getAttribute("data-js-image-error") === "true") {
      error.removeAttribute("data-js-image-error");
    }

    if (!value) {
      this.pushEvent("imageLoadingState.loaded", {
        id,
      });
    }
  },

  setImageErrorState() {
    const image = this.el;
    const id = image.getAttribute("id");
    const skeleton = document.getElementById(`skeleton-${id}`);
    const placeholder = document.getElementById(`placeholder-${id}`);
    const error = document.getElementById(`error-${id}`);

    image.setAttribute("data-js-image-error", true);
    skeleton?.setAttribute("data-js-image-error", true);
    placeholder?.setAttribute("data-js-image-error", true);
    error?.setAttribute("data-js-image-error", true);

    image.setAttribute("data-js-loading", false);
    skeleton?.setAttribute("data-js-image-loading", false);
    placeholder?.setAttribute("data-js-image-loading", false);
    error?.setAttribute("data-js-image-loading", false);

    this.pushEvent("imageLoadingState.error", {
      id,
    });
  },
};

export default imageLoadingState;
