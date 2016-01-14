/**
 * This class allows a case to be created by a site guest user for their
 * Account. Account lookup is done on the Customer_Number__c field.
 */
public without sharing class CreateServiceOrderCtrl {

  /**
   * The customer number input from the user.
   */
  public String customerNumber {get;set;}

  /**
   * The case record that the user will be filling out
   * and submitting. The accountId for the case starts null
   * and is set when doing the account lookup based on the
   * customerNumber provided by the user.
   */
  public Case caseRecord {get;set;}

  /**
   * Standard constructor that does not do any initialization.
   */
	public CreateServiceOrderCtrl() {
    caseRecord = new Case();
	}

  /**
   * Lookup an Account based on the customerNumber that the user entered. If
   * one is found, caseRecord.AccountId is set. If not, a page message is added.
   */
  public void doAccountLookup() {
    try {
      caseRecord.AccountId = [SELECT Id FROM Account WHERE Customer_Number__c = :customerNumber].Id;
    }
    catch(exception e) {
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.severity.ERROR, 'We could not find an account for "' + customerNumber + '"' + e.getMessage())
      );
    }
  }

  /**
   * Insert the Case record. A page message is added for either success
   * or failure. If the insert is successful, refresh() should be called
   * before making a new case.
   */
  public void submitCase() {
    try {
      insert caseRecord;
      String caseNumber = [SELECT CaseNumber FROM Case WHERE Id = :caseRecord.Id].CaseNumber;
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.severity.CONFIRM, 'Your service order #' + caseNumber + ' has been submitted.')
      );
    }
    catch(exception e) {
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.severity.ERROR, 'There was a problem submitting your service order. Details: ' + e.getMessage())
      );
    }
  }

  /**
   * Refresh the page by returning a new PageReference for this page with
   * redirect set to true.
   *
   * @return    Return a redirect to this page.
   */
  public PageReference refresh() {
    PageReference newPage = Page.CreateServiceOrder;
    newPage.setRedirect(true);
    return newPage;
  }
}