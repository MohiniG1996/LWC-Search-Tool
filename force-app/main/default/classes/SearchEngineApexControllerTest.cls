@isTest
public class SearchEngineApexControllerTest {
    /**This Method is for Setting up the Test Data**/
    @testSetup 
    static void setUpTestData() {
        List<Account> accList=new List<Account>();
        for(integer i=0; i<200; i++){
            Account accRec = new Account();
            accRec.Name = 'Account Record'+i;
            accList.add(accRec);
        }
        insert accList;
        
    }
    /**This method used for postive scenario for getAllRecords() method**/
    @isTest
    static void getAllRecords_Test(){
        SearchEngineApexController searchEngineObj = new SearchEngineApexController (); 
        SearchEngineApexController.ObjectDetailsWrapper wrapperObj=SearchEngineApexController.getAllRecord('Account', 'Name', '200');
        System.debug('wrapperObj==>'+wrapperObj);
        system.assertEquals(200, wrapperObj.allRecords.size());
        
    }
	/**This method used for negative scenario for getAllRecords() method**/
    @isTest
    static void getAllRecords_NegativeTest(){
        boolean isallRecordsEmpty=false;
        SearchEngineApexController.ObjectDetailsWrapper wrapperObj=SearchEngineApexController.getAllRecord('Account', 'InvalidField', '200');
        if(wrapperObj.allRecords==null){
             isallRecordsEmpty=true;
        }
		System.assertEquals(true,isallRecordsEmpty);

    }
	/**This method used for Positive scenario for updateObject() method**/
    @isTest
    static void updateObject_test(){
        List<Account> accRec = [select id,name from account where name='Account Record0'];
       String response= SearchEngineApexController.UpdateObject(accRec);
		system.assertEquals('Success',response);

    }
	/**This method used for negative scenario for updateObject() method**/
	@isTest
    static void updateObject_Negativetest(){
       String response= SearchEngineApexController.UpdateObject(null);
        if(response==null){
            response='failure';
        }
		system.assertEquals('failure',response);

    }


}