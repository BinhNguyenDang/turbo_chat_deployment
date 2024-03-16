import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    initialize() {
        console.log("Initialized");
        this.messages = document.getElementById("messages");
        this.resetScrollWithoutThreshold(this.messages);
    }
    /** On start */
    connect(){
        console.log("Connected Scroll");
        
        // Create an observer instance linked to the resetScroll method
        this.observer = new MutationObserver(mutations => {
            mutations.forEach(mutation => {
                if (mutation.type === 'childList') {
                    this.resetScroll();
                }
            });
        });
        
        // Start observing the target node for configured mutations
        this.observer.observe(this.messages, {
            childList: true, // Observe direct children additions and removals
            subtree: false, // Do not observe all descendants, just direct children
        });
    }
    /** On stop */
    disconnect(){
        console.log("Disconnected");
        // Disconnect the observer when the controller is disconnected
        this.observer.disconnect();
    }
    /**Custom function */
    resetScroll(){
        const bottomOfScroll = this.messages.scrollHeight - this.messages.clientHeight;
        const upperScrollThreshold = bottomOfScroll - 200;
        // Scroll down if we're not within the threshold
        if (this.messages.scrollTop > upperScrollThreshold){
            this.messages.scrollTop = this.messages.scrollHeight - this.messages.clientHeight;
        }
    }
    resetScrollWithoutThreshold(messages){
        messages.scrollTop = messages.scrollHeight - messages.clientHeight;
    }
}
