public with sharing class SearchEngineApexController {
    /**This Method fetches the all records of an object**/
    @AuraEnabled(cacheable=true)
    public static SearchEngineApexController.ObjectDetailsWrapper getAllRecord(String objectName,String fieldNames,String RecordLimit) {
        List<sObject> sobjList;
        SearchEngineApexController.ObjectDetailsWrapper wrapperObj=new SearchEngineApexController.ObjectDetailsWrapper();
        try{
           if(objectName!=null && objectName!='' && fieldNames!=null && fieldNames!=null &&  RecordLimit!=null && RecordLimit!='' ){
               String query = 'SELECT '+fieldNames+'  FROM '+objectName+' LIMIT '+RecordLimit;
               sobjList = Database.query( query );
               wrapperObj.objName=objectName;
               wrapperObj.allRecords=sobjList;
               wrapperObj.allFieldsDetail=prepareFieldDetailsWrapper(objectName,fieldNames);
           }
        }catch(Exception e){
            System.debug('Error Line Number:'+e.getLineNumber()+'Error Message'+e.getMessage());
        }
        return wrapperObj;
    }    
    /**This Method basically used to perform update in object**/
    @AuraEnabled
    public static String updateObject(List<sobject> dataToUpdate) {
        try {
            if(dataToUpdate!=null){
                update dataToUpdate;
                return 'Success';
            }
            return null;
        }
        catch (Exception e) {
                System.debug('Error Line Number:'+e.getLineNumber()+'Error Message'+e.getMessage());
            return 'failure';
        }
    }
    /**This Method is used to prepare FieldDetailWrapper which contains all the details about fields**/
    public static List<SearchEngineApexController.FieldDetailsWrapper> prepareFieldDetailsWrapper(String ObjectApi,String fieldNames){
		List<SearchEngineApexController.FieldDetailsWrapper> fieldWrapperList=new List<SearchEngineApexController.FieldDetailsWrapper>();
        try {
            List<String> fieldsAPINameList = fieldNames.split(',');
            for(String fieldAPIName:fieldsAPINameList){
                SearchEngineApexController.FieldDetailsWrapper fieldWrapper=new SearchEngineApexController.FieldDetailsWrapper();
                fieldWrapper.label=getLabelsfromAPINames(ObjectApi,fieldAPIName);
                fieldWrapper.fieldName=fieldAPIName;
                fieldWrapper.type=getFieldTypeByAPINames(ObjectApi,fieldAPIName);
                fieldWrapper.editable=true;
                fieldWrapper.sortable=true;
                fieldWrapperList.add(fieldWrapper);
            }
        } catch (Exception e) {
            System.debug('Error Line Number:'+e.getLineNumber()+'Error Message'+e.getMessage());
            throw e;
        }
        return fieldWrapperList;
    }
    /**This method fetch the label name of a field**/
    private static String getLabelsfromAPINames(String ObjectApi, String FieldApi){
        String labelName='';
        try{
            if(!String.IsBlank(ObjectApi) && !String.IsBlank(FieldApi)){
                labelName=(String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(FieldApi).getDescribe().getLabel();
            }
        }catch(Exception e){
            System.debug('Error Line Number:'+e.getLineNumber()+'Error Message'+e.getMessage());
            throw e;
        }
        return labelName;
    }
    /**This method fetch the API Name of a field**/
    private static String getFieldTypeByAPINames(String ObjectApi, String FieldApi){
        SObjectType r = ((SObject)(Type.forName('Schema.'+ObjectApi).newInstance())).getSObjectType();
        DescribeSObjectResult d = r.getDescribe();
        Schema.DisplayType fielddataType=d.fields.getMap().get(FieldApi).getDescribe().getType();
        return String.valueOf(fielddataType);
    }
    public class ObjectDetailsWrapper {
        @AuraEnabled
        public string objName{get;set;}
        @AuraEnabled
        public List<sobject> allRecords { get; set; }
        @AuraEnabled
        public List<FieldDetailsWrapper> allFieldsDetail { get; set; }
    }
    public class FieldDetailsWrapper{
        @AuraEnabled
        public string label{get;set;}
        @AuraEnabled
        public string fieldName{get;set;}
        @AuraEnabled
        public string type{get;set;}
        @AuraEnabled
        public boolean editable{get;set;}
        @AuraEnabled
        public boolean sortable{get;set;}
    }
}