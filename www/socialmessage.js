var exec = require("cordova/exec");

var SocialMessage = function () {
    this.name = "SocialMessage";
};

var allActivityTypes = ["PostToFacebook", "PostToTwitter", "PostToWeibo", "Message", "Mail", "Print", "CopyToPasteboard", "AssignToContact", "SaveToCameraRoll", "AddToReadingList", "PostToFlickr", "PostToVimeo", "TencentWeibo", "AirDrop"];

SocialMessage.prototype.send = function (config, onSuccess, onError) {
  if ( !config ) return;
  if ( typeof (config.activityTypes) === 'undefined' || config.activityTypes === null || config.activityTypes.length === 0 ) {
    config.activityTypes = allActivityTypes;
  }
  config.activityTypes = config.activityTypes.join(',');
  exec(onSuccess || null, onError || null, "SocialMessage", "send", [config]);
};

module.exports = new SocialMessage();