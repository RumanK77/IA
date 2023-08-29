/*({
	myAction : function(component, event, helper) {
	}
	
})*/
({
    handleUploadFinished: function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var fileId = uploadedFiles[0].documentId;
        var action = component.get("c.processCSVFile");
        action.setParams({ fileId: fileId });
        $A.enqueueAction(action);
    }
})