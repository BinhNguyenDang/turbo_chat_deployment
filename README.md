# README
* 3/6/2024 Fixed Local Disk on first repo corrupted, changing repo and reset sqlite database.
* Adding Devise Avatars using ActiveStorage
* Status Funtion updated in real time (3/11/2024)
-----------------------------------------------------------------------------------------------------------------------------------------
* The primary issue with the initial code setup, especially concerning the real-time user status updates, lies in the intricacies of how Rails, specifically with Turbo Rails and Action Cable, handles real-time updates and how these mechanisms were utilized in your application. Here's a detailed breakdown:
-------------------------------------------------------------------------------------------------------------------------------------------
* Original Problems
* Broadcasting Mechanism Clarity: Your original User model used a general approach for broadcasting updates after creating a user with broadcast_append_to "users" and a non-specific broadcast_update. While broadcast_append_to correctly appends a newly created user to a list of users, the broadcast_update was intended to update a user's status in real time but lacked specificity in targeting. Without a specific target, updates might not reach the intended elements or might not trigger the expected DOM changes.

* Subscription and Targeting in Views: The views setup, particularly in users/_status.html.erb and the way it's included in other views like rooms/index.html.erb, didn't specify how to target individual user statuses for updates. The use of a generic subscription with turbo_stream_from "user_status" in your _user.html.erb didn't tie back to individual user updates directly, which could lead to the inability to update statuses in real-time correctly.

* Lack of Specific Stream Targeting for User Statuses: Real-time updates require precise targeting to ensure that an update intended for one user's status correctly finds its way to the specific DOM element representing that user's status. The initial setup didn't differentiate between different users for the purpose of status updates, which could cause the real-time mechanism to falter, not updating the UI as expected.
-------------------------------------------------------------------------------------------------------------------------------------------
* Solutions and Improvements
* Specific Broadcasting for Status Updates: By introducing a method like broadcast_status_update in the User model and calling it with after_update_commit only when the status changes (if: :saved_change_to_status?), the broadcast is now specifically tied to status updates. This ensures that only relevant changes trigger a broadcast, reducing unnecessary network traffic and focusing the updates.

* Precise Turbo Stream Subscriptions: Adjusting the views to use turbo_stream_from "user_status:#{user.id}" creates a unique channel for each user's status updates. This means that when a status update is broadcasted for a user, it is correctly targeted and received by the specific DOM element subscribed to that user's status stream. This precision in targeting is crucial for real-time updates to function correctly.

* Correctly Targeting DOM Elements: By ensuring that the target for status updates (target: "user_status_#{self.id}") matches the ID of the DOM element intended for these updates, the system knows exactly where to apply the changes. This alignment between broadcast targets and DOM element IDs is essential for Turbo to correctly replace or update the content in real time.
--------------------------------------------------------------------------------------------------------------------------------------------------
