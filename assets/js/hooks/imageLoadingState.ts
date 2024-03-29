/**
 * JS Hook for setting data attributes for image loading states
 */
import { ViewHook } from "phoenix_live_view";

const SKELETON_PREFIX = `skeleton-`;
const PLACEHOLDER_PREFIX = `placeholder-`;
const ERROR_PREFIX = `error-`;

const IMAGE_LOADING_ATTRIBUTE = "data-js-loading";
const IMAGE_RELATIVE_LOADING_ATTRIBUTE = "data-js-image-loading";

const IMAGE_ERROR_ATTRIBUTE = "data-js-error";
const IMAGE_RELATIVE_ERROR_ATTRIBUTE = "data-js-image-error";

interface ImageLoadingState extends Partial<Omit<ViewHook, "el">> {
  el?: HTMLImageElement;
  setImageLoadingState: (value: boolean) => void;
  setImageErrorState: () => void;
}

const imageLoadingState = {
  mounted(this: ImageLoadingState) {
    const image = this.el;
    const id = image.getAttribute("id");
    const skeleton = document.getElementById(`${SKELETON_PREFIX}${id}`);
    const placeholder = document.getElementById(`${PLACEHOLDER_PREFIX}${id}`);

    this.setImageLoadingState(!image.complete);

    image.addEventListener("load", () => {
      this.setImageLoadingState(false);
    });
    image.addEventListener("error", () => {
      this.setImageErrorState();
    });
    placeholder?.addEventListener("load", () => {
      skeleton?.setAttribute(
        IMAGE_RELATIVE_LOADING_ATTRIBUTE,
        false.toString()
      );
    });
    placeholder?.addEventListener("error", () => {
      // Handle error state later
    });
  },

  setImageLoadingState(this: ImageLoadingState, value: boolean) {
    const image = this.el;
    const id = image.getAttribute("id");
    const skeleton = document.getElementById(`${SKELETON_PREFIX}${id}`);
    const placeholder = document.getElementById(`${PLACEHOLDER_PREFIX}${id}`);
    const error = document.getElementById(`${ERROR_PREFIX}${id}`);

    const newValue = value.toString();

    image.setAttribute(IMAGE_LOADING_ATTRIBUTE, newValue);
    skeleton?.setAttribute(IMAGE_RELATIVE_LOADING_ATTRIBUTE, newValue);
    placeholder?.setAttribute(IMAGE_RELATIVE_LOADING_ATTRIBUTE, newValue);
    error?.setAttribute(IMAGE_RELATIVE_LOADING_ATTRIBUTE, newValue);

    if (image.getAttribute(IMAGE_ERROR_ATTRIBUTE) === "true") {
      image.removeAttribute(IMAGE_ERROR_ATTRIBUTE);
    }

    if (skeleton?.getAttribute(IMAGE_RELATIVE_ERROR_ATTRIBUTE) === "true") {
      skeleton.removeAttribute(IMAGE_RELATIVE_ERROR_ATTRIBUTE);
    }

    if (placeholder?.getAttribute(IMAGE_RELATIVE_ERROR_ATTRIBUTE) === "true") {
      placeholder.removeAttribute(IMAGE_RELATIVE_ERROR_ATTRIBUTE);
    }

    if (error?.getAttribute(IMAGE_RELATIVE_ERROR_ATTRIBUTE) === "true") {
      error.removeAttribute(IMAGE_RELATIVE_ERROR_ATTRIBUTE);
    }

    if (!value) {
      this.pushEvent("imageLoadingState.loaded", {
        id,
      });
    }
  },

  setImageErrorState(this: ImageLoadingState) {
    const image = this.el;
    const id = image.getAttribute("id");
    const skeleton = document.getElementById(`${SKELETON_PREFIX}${id}`);
    const placeholder = document.getElementById(`${PLACEHOLDER_PREFIX}${id}`);
    const error = document.getElementById(`${ERROR_PREFIX}${id}`);

    const errorValue = true.toString();
    image.setAttribute(IMAGE_ERROR_ATTRIBUTE, errorValue);
    skeleton?.setAttribute(IMAGE_RELATIVE_ERROR_ATTRIBUTE, errorValue);
    placeholder?.setAttribute(IMAGE_RELATIVE_ERROR_ATTRIBUTE, errorValue);
    error?.setAttribute(IMAGE_RELATIVE_ERROR_ATTRIBUTE, errorValue);

    const loadingValue = false.toString();
    image.setAttribute(IMAGE_LOADING_ATTRIBUTE, loadingValue);
    skeleton?.setAttribute(IMAGE_RELATIVE_LOADING_ATTRIBUTE, loadingValue);
    placeholder?.setAttribute(IMAGE_RELATIVE_LOADING_ATTRIBUTE, loadingValue);
    error?.setAttribute(IMAGE_RELATIVE_LOADING_ATTRIBUTE, loadingValue);

    this.pushEvent("imageLoadingState.error", {
      id,
    });
  },
} satisfies ImageLoadingState;

export default imageLoadingState;
