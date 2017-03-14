process web_test {
action overview {
script { "<p>In this exercise, you will create a set of tests for the Web
    interface to the PML virtual machine, using JUnit and HTTPUnit.
    The procedure is an abbreviated version of Tamres incremental
    approach; the baseline is provided for you, you just need to do
    the inventory.</p><p>JUnit is a Java framework for creating and running unit and
    functional tests.  HTTPUnit is a set of java classes that one
    uses in conjunction with JUnit for testing web sites.</p>" }
}
sequence setup_environment {
action create_working_directory {
provides { working_directory }
script { "<p>Create a working directory to contain the java files that
      implement your tests.  You <b>must</b> set permissions on the
      path to your working directory so that the PEOS web interface
      can traverse the path and read your test files.</p><pre>
      % cd
      % chmod a+X .
      % mkdir coen286
      % chmod a+X coen286
      % cd coen286
      % mkdir web_test
      % chmod a+Xr web_test
      </pre><p>Please pay particular attention to the last <i>chmod</i>; you
      must make your working directory both <i>executable</i> (`+X')
      and <i>readable</i> (`+r'), 
      so that the PML Web interface can read and display your files
      when requested.  The other directories need only be
      <i>executable.</i></p><p>Note: this only grants read access to your working directory;
      and only allows others to traverse, but not read, the
      directories in the path leading to your working directory. This
      enables the PEOS web interface to find your test files and other
      resources in your working directory, but does not allow anyone to
      actually list any of your directories except for your working
      directory.</p>" }
}
action create_test_file {
requires { working_directory }
provides { junit_test_file }
script { "

      HTTPUnit and JUnit are written in Java, and require tests to be
      written in Java as well. Create a Java file to contain your test
      code (called a Test Case in JUnit terminology).  You must also
      set permissions on the test file so that the PEOS web interface
      can traverse the path and read your test files.
      <pre>
      % cd ~/coen286/web_test
      % touch WebUITest.java
      % chmod a+r WebUITest.java
      </pre>
      Note: the last step is necessary to grant access to the PEOS web
      ui.

      Put the following skeleton in your java test file, then modify
      the values of the <i>login</i> and <i>password</i> variables.
      Set the <i>login</i> variable to the <i>test</i> id you received
      via email; the password is the same for both IDs.
      <pre>
      import java.lang.*;
      import com.meterware.httpunit.*;

      import java.io.IOException;
      import java.net.MalformedURLException;

      import org.xml.sax.*;
      import org.w3c.dom.*;

      import junit.framework.*;


      /**
       * An example of testing web2 using httpunit and JUnit.
       **/
      public class WebUITest extends TestCase {

	  String site = &quot;http://linux.students.engr.scu.edu/~jnoll/PEOS/cgi-bin/&quot;;
	  String login = &quot;(your test login)&quot;;
	  String passwd = &quot;(your password)&quot;;
	  // Static, so initialization in Baseline persists.
	  static String proc_table; 


	  public static void main(String args[]) {
	      junit.textui.TestRunner.run( suite() );
	  }

	  public static Test suite() {
	      return new TestSuite( WebUITest.class );
	  }

	  public WebUITest( String name ) {
	      super( name );
	  }

	  public void testBaseline () throws Exception {
	      assertTrue(0 == 0);
	  }
      }
      </pre><p>Be sure to include the <i>main()</i>and <i>suite()</i>methods in
      addition to the constructor; JUnit uses these to run your tests.</p><p>Note: The JUnit <i>TestCase</i> class corresponds to our notion
      of test procedures.  The methods of this class are close to our
      concept of test case.</p><p>To verify that everything is set up correctly, this skeleton
      includes a simple test method to your class that will be run by
      JUnit when the test is run:</p><pre>
      assertTrue(0 == 0);
      </pre>
      will result in a `.' appearing in the output, indicating a test
      was run and passed.

      " }
}
action create_makefile {
requires { working_directory }
provides { Makefile }
script { "

      Create a Makefile to automate the build and run cycle: 
      <pre>
      % touch Makefile
      % chmod a+r Makefile
      </pre>
      Put the following macros and rules in the Makefile (please be
      sure to include the 'test' rule, so I can easily run your tests by
      typing 'make test'). 
      <pre>
      HTTPUNIT = /home/jnoll/lib/httpunit-1.5.4
      CLASSPATH = .:..:$(HTTPUNIT)/lib/httpunit.jar:$(HTTPUNIT)/jars/junit.jar:$(HTTPUNIT)/jars/nekohtml.jar:$(HTTPUNIT)/jars/Tidy.jar:$(HTTPUNIT)/jars/xmlParserAPIs.jar:$(HTTPUNIT)/jars/xercesImpl.jar:$(HTTPUNIT)/jars/js.jar
      
      JAVAC = javac
      JAVA = java
      
      test: WebUITest.class
      	       $(JAVA) -classpath $(CLASSPATH) WebUITest
      
      %.class: %.java
	       $(JAVAC) -classpath $(CLASSPATH) $<
      </pre><p>Note: be sure the lines containing JAVA and JAVAC above are
      preceded by a <i>tab</i> character; make will be confused otherwise.
      </p>" }
}
action verify_setup {
requires { working_directory }
script { "

      Verify that your environment has been set up correctly by
      compiling and running the test.  To do this, you need to add
      <i>javac</i> and <i>java</i> to your path, which is easily done
      using the <i>setup</i> command:
      <pre>
      % setup jdk
      % setup gcc
      </pre>
      This will automatically add the appropriate environment
      variables for the current version of JDK, as well as
      <i>gmake</i>, to your environment.

      <p>Now, test your implementation:</p><pre>
      % gmake test
      </pre>
      You should see something like the following: 
      <pre>
[jnoll@linux101] ~/src/webtest :make
javac -classpath .:..:/home/jnoll/lib/httpunit-1.5.4/lib/httpunit.jar:/home/jnoll/lib/httpunit-1.5.4/jars/junit.jar:/home/jnoll/lib/httpunit-1.5.4/jars/nekohtml.jar:/home/jnoll/lib/httpunit-1.5.4/jars/Tidy.jar:/home/jnoll/lib/httpunit-1.5.4/jars/xmlParserAPIs.jar:/home/jnoll/lib/httpunit-1.5.4/jars/xercesImpl.jar:/home/jnoll/lib/httpunit-1.5.4/jars/js.jar WebUITest.java
java -classpath .:..:/home/jnoll/lib/httpunit-1.5.4/lib/httpunit.jar:/home/jnoll/lib/httpunit-1.5.4/jars/junit.jar:/home/jnoll/lib/httpunit-1.5.4/jars/nekohtml.jar:/home/jnoll/lib/httpunit-1.5.4/jars/Tidy.jar:/home/jnoll/lib/httpunit-1.5.4/jars/xmlParserAPIs.jar:/home/jnoll/lib/httpunit-1.5.4/jars/xercesImpl.jar:/home/jnoll/lib/httpunit-1.5.4/jars/js.jar WebUITest
.
Time: 0.003

OK (1 test)

[jnoll@linux101] ~/src/webtest :
      </pre>
      Notice the lone '.' before the ``Time: 0.026''.  This indicates
      a test was run and passed.

      " }
}
}
action create_baseline {
requires { junit_test_file }
script { "

    Once you have a working test setup, augment it to interact with
    the PEOS system. HTTPUnit provides several methods for
    simulating interactions with a web site. You must first create a
    ``conversation'' object to encapsulate the interactions with the
    web site. First, set the <i>login</i> and <i>passwd</i>
    variables to your <i>test</i> login id and passwd:
    <pre>
       String login = &quot;(your test login)&quot;;
       String passwd = &quot;(your password)&quot;;
    </pre>
    Then, replace the body of your <i>testBaseline()</i> with the
    following:
    <pre>
    public void testBaseline() throws Exception {
    	  WebConversation conversation = new WebConversation();
    	  conversation.setAuthorization(login, passwd);
    	  WebRequest request = 
	      new GetMethodWebRequest(site + &quot;action_list.cgi&quot;);
    	  WebResponse response = conversation.getResponse(request);
    
    	  // Verify title and heading of response page.
    	  String title = response.getTitle();
    	  assertNotNull(title);
    	  assertEquals(&quot;Action List&quot;, title);
    	  assertTrue(-1 != response.getText().indexOf(&quot;Action List&quot;));
    
    	  // Save the name of the process table; required for future
    	  // tests that have to send process table name in the url.
    	  WebForm form = response.getForms()[0];
    	  proc_table = form.getParameterValue(&quot;process_filename&quot;);
    	  assertNotNull(proc_table);
    }
    </pre><p>First, note the <i>WebConversation</i> object in the above method
    definition.  This object manages the sending and receiving of
    requests and responses to and from the server. The conversation
    also manages authentication, which is necessary for interacting
    with the PEOS web site.  Therefore, you must include your test
    login id and password in the code.</p><p>Next, observe how we sent a request to the web server.  This is
    done using a <i>request</i> object that is returned by the
    <i>GetMethodWebRequest()</i> method, which takes a URL as
    argument.  We pass this object to the <i>WebConversation</i> to
    send to the web server.  We get the reply contents by asking the
    <i>WebConversation</i> for the <i>response</i> object.</p><p>The <i>response</i>object represents the reply from the web
    server. This object can be queried for various constructs that
    are part of the web page returned, including forms in the page,
    and parameters in the forms. An important parameter you will
    want to retrieve is the <i>process_filename</i>, which is the
    name of the file that stores the process table for your
    processes. (Each user gets a separate process table, with name
    derived from the encrypted user name. This is to provide a
    measure of privacy, so others can't easily obtain your process
    state, or identify who belongs to a given process table.)
    Declare an instance variable (say, <i>proc_table</i>) to hold
    this name (you will need it later), and retrieve it from the
    response:</p><pre>
        WebForm form = response.getForms()[0];
    	  proc_table = form.getParameterValue(&quot;process_filename&quot;);
    	  assertNotNull(proc_table);
    </pre>
    Note the use of <i>assertNotNull()</i>. This is a JUnit
    assertion to assert that its argument is not Null.

    <p>Finally, we employ several HTTPUnit methods to examine the
    response.  In particular, <i>getTitle()</i> returns the pages
    title (obviously), and <i>getText()</i> returns the text (not the
    header) of the page, as html if it is an html page.  For a
    complete list of HTTPUnit operations, see the <a>HTTPUnit
    API documentation</a>.</p>" }
}
iteration create_inventory_tests {
action select_inventory_item {
script { "<p>As mentioned previously, the test procedure is an abbreviated
      form of Tamres incremental approach.  In this phase, you create
      a test for each ``inventory'' item in the product's input.</p><p>The following cgi pages represent the inventory items to
      test:</p><ul><li>action_list.cgi</li><li>create_process.cgi</li><li>action_page.cgi</li><li>bind_resources.cgi</li><li>delete_proc_table.cgi</li></ul><p>Select an item to test, then create a test method named after
      the item.  For example, if you choose to test
      <i>action_list.cgi</i>, name your method <i>testActionList</i>.
      Note: it is necessary to create a name that begins with the
      string ``test''; JUnit uses reflection to find the test methods
      to call, by looking for this prefix string.  It won't run
      methods that don't begin with this string.</p><p>Then, select one or more of the following tests to add to
      your test method, depending on the page under test.
      </p><p>Note: if you're clever about the order in which you implement
      your tests, you can leverage one test to set up the next.  For
      example, don't test <i>delete_proc_table.cgi</i> until the end;
      then, you can use successful results of
      <i>create_process.cgi</i> tests to set up the environment for
      the others.</p>" }
}
iteration  {
selection  {
action retrieve_page {
requires { junit_test_file }
script { "

	  The baseline test is an example of how to test simple
	  retrieval of a web page: create a <i>request</i> bound to a
	  specific url, use the <i>WebConversation</i> to submit the
	  request, then examine the <i>response</i> object representing
	  the reply.

	  " }
}
action create_process {
requires { junit_test_file }
script { "

	  You will need to create a process instance to test some
	  operations, such as the <i>action_page.cgi</i>.  This is
	  easy: just submit a request for <i>create_process.cgi</i>
	  with the name of the process:
	  <pre>
	  WebConversation conversation = new WebConversation();
	  conversation.setAuthorization(login, passwd);
	  WebRequest request = 
	  	  new GetMethodWebRequest(site 
	  				  + &quot;create_process.cgi?&quot;
	  				  + &quot;model=test_action.pml&quot;
	  				  + &quot;&process_filename=&quot; + proc_table);
	  
	  // Submit request and get reply.
	  WebResponse response = conversation.getResponse(request);
	  
	  // Verify title and heading of response page.
	  // The response to create_process is the Action List page.
	  String title = response.getTitle();
	  assertNotNull(title);
	  assertEquals(&quot;Action List&quot;, title);
	  assertTrue(-1 != response.getText().indexOf(&quot;&lt;h1&gt;Action List&lt;/h1&gt;&quot;));
	  </pre>" }
}
action reset_process_table {
requires { junit_test_file }
script { "

	  Some tests will require a ``clean'' environment, in which no
	  processes have been created.  Use
	  <i>delete_proc_table.cgi</i> to delete the process table and
	  thus reset the environment:
	  <pre>
	  WebConversation conversation = new WebConversation();
	  conversation.setAuthorization(login, passwd);
	  assertNotNull(proc_table);
	  WebRequest request = 
	      new GetMethodWebRequest(site 
				      + &quot;delete_proc_table.cgi?&quot;
				      + &quot;process_filename=&quot; + proc_table);

	  // Submit request and get reply.
	  WebResponse response = conversation.getResponse(request);

	  // Verify title and heading of response page.
	  // The response to delete_proc_table.cgi is a message confirming
	  // delete.  
	  String title = response.getTitle();
	  assertNotNull(title);
	  assertEquals(&quot;Delete Process Table&quot;, title);
	  assertTrue(-1 != response.getText().indexOf(&quot;&lt;h1;&gt;Delete Process Table&lt;/h1&gt;&quot;));
	  </pre>" }
}
action verify_links {
requires { junit_test_file }
script { "

	  A page containing links can be verified by examining the text
	  between the anchor tags, or the link url.  

	  <p>Use the <i>WebResponse</i> object's <i>getLinkWith()</i>
	  method to find a link with specific text within anchor tags.
	  For example, to find the ``overview'' link in a page, do </p><pre>
	  // Get 'overview' link from form.
	  WebLink link = response.getLinkWith(&quot;overview&quot;);
	  assertNotNull(link);
	  </pre><p>Then, you can verify the the link's url with
	  <i>getURLString()</i>:</p><pre>
	  assertEquals(&quot;action_page.cgi?pid=0&act_name=overview&quot; + 
		       &quot;&process_filename=&quot; + proc_table,
		       link.getURLString());
	  </pre><p>Another way to look at links is to retrieve all of the
	  links in a page, then look at their attributes one at a
	  time:</p><pre>
	  // Verify links.  This process only has two links: ``test_script''
	  // and ``Create Process''.
	  WebLink links[] = response.getLinks();
	  int i = 0;
	  assertEquals(&quot;test_script&quot;, links[i].asText());
	  assertEquals(&quot;action_page.cgi?pid=0&act_name=test_script&quot; + 
		       &quot;&process_filename=&quot; + proc_table,
		       links[i].getURLString());
	  i++;
	  // Next link is ``Create Process'' link at bottom of page.
	  assertEquals(&quot;Create Process&quot;, links[i].asText());
	  assertEquals(&quot;process_listing.cgi?&quot; + 
		       &quot;process_filename=&quot; + proc_table,
		       links[i].getURLString());
	  </pre>" }
}
action follow_link {
requires { junit_test_file }
script { "<p>Links aren't much use if they can't be followed.  HTTPUnit
	  provides a facility for following links, simulating a mouse
	  click on the anchor text.  This is achieved through the
	  <i>WebLink</i> object's <i>click()</i>method:</p><pre>
	  // See if there's anything on the other end.
	  WebResponse linkEnd = links[i].click();
	  assertNotNull(linkEnd.getTitle());
	  assertEquals(&quot;test_script&quot;, linkEnd.getTitle());
	  assertTrue(-1 != linkEnd.getText().indexOf(&quot;&lt;h1&gt;test_script&lt;/h1&gt;&quot;));
	  </pre>" }
}
action verify_parameters {
requires { junit_test_file }
script { "<p>Most of the web pages we will test are actually forms.
	  HTTPUnit provides many facilities for examining and
	  manipulating forms.</p><p>For example, you might want to examine a form's
	  parameters; we used this in the baseline test to obtain the
	  process table name, which is a ``hidden'' parameter in most
	  of our forms:</p><pre>
	   <input type=&quot;hidden&quot; name=&quot;process_filename&quot; value=&quot;dfTqHEvIkEM2.dat&quot;>
	  </pre><p>We retrieved this parameter using the <i>WebForm</i>
	  object's <i>getParameterValue()</i> method, which takes the
	  parameter name as argument and returns the parameter's value
	  attribute:</p><pre>
	   WebForm form = response.getForms()[0];
	   proc_table = form.getParameterValue(&quot;process_filename&quot;);
	  </pre>" }
}
action submit_form {
requires { junit_test_file }
script { "

	  You can also submit a form, once you have obtained it using
	  the <i>WebResponse</i> objects <i>getForms()</i> method.

	  <p><i>WebForm</i> provides a <i>setParameter()</i> method to set
	  the values of a forms parameters, and a <i>submit()</i>
	  method that simulates form submission.</p><pre>

	  WebConversation conversation = new WebConversation();
	  conversation.setAuthorization(login, passwd);
	  WebRequest  request = 
	      new GetMethodWebRequest(site + &quot;handle_run.cgi?&quot;
				      + &quot;resource_type=requires&quot; 
				      + &quot;&process_filename=&quot; + proc_table
				      + &quot;&pid=0&quot;
				      + &quot;&act_name=test_script&quot;);

	  WebResponse response = conversation.getResponse( request );
	  WebForm bindingForm = response.getForms()[0];
	  bindingForm.setParameter(&quot;test_resource&quot;, &quot;/home/jnoll/lib/httpunit&quot;);
	  bindingForm.submit();

	  // The response is now the conversation's current page.
	  response = conversation.getCurrentPage();
	  assertEquals(&quot;test_script&quot;, response.getTitle());

	  </pre>" }
}
action examine_table {
requires { junit_test_file }
}
}
}
action verify_test_method {
requires { junit_test_file }
script { "

      Verify that your test compiles and runs before proceeding to the
      next test:
      <pre>
      % make test
      </pre>" }
}
}
action create_readme {
requires { working_directory }
provides { readme }
script { "
    Create a README file in your working directory, that identifies
    you and answers a few questions about your experience.  Use the
    following template as a starting point:
    <pre>
      Ed Student
      123456

      Questions:
      1. Did you use the ``Check to Indicate Done'' feature of the
      Action List?

      2. Did you perform any tasks out of order?

      3. Did you ever click the ``Run'' and/or ``Done'' buttons of
      the Action Page?

      4a. Please assess the PEOS interface as more or less helpful than the
      static web pages we have used to explain earlier assignments
      (put an `X' in the box next to your assessment):
      [ ] definitely more helpful 
      [ ] somewhat more helpful 
      [ ] somewhat less helpful 
      [ ] definitely less helpful

      4b. Please write a brief explanation for your answer to part
      (a).

      5. Please write any other impressions about your experience
      here.

    </pre>" }
}
action submit_results {
requires {  junit_test_file && readme  }
script { "

    Once you are satisfied with your test suite (and only after you
    have verified that ALL tests compile and run), submit a tar file
    via email, according to the <a>submit
    procedure</a>.

    " }
}
}
