import "preline/preline";
import { type IStaticMethods } from "preline/preline";
import HSComboBox from "@preline/combobox";

declare global {
    interface Window {
        HSComboBox: typeof HSComboBox;
        HSStaticMethods: IStaticMethods;
    }
}

// Ensure code only runs in browser environment
if (typeof window !== 'undefined') {
    window.HSComboBox = HSComboBox;
}

// Define Nuxt plugin
export default defineNuxtPlugin((nuxtApp) => {
    nuxtApp.hook("page:finish", () => {
        // Initialize components when page loads
        if (window.HSStaticMethods?.autoInit) {
            window.HSComboBox.autoInit();
            window.HSStaticMethods.autoInit();
        }
    });
});