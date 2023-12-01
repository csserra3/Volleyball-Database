<!-- Test Oracle file for UBC CPSC304
  Created by Jiemin Zhang
  Modified by Simona Radu
  Modified by Jessica Wong (2018-06-22)
  Modified by Jason Hall (23-09-20)
  This file shows the very basics of how to execute PHP commands on Oracle.
  Specifically, it will drop a table, create a table, insert values update
  values, and then query for values
  IF YOU HAVE A TABLE CALLED "demoTable" IT WILL BE DESTROYED
  The script assumes you already have a server set up All OCI commands are
  commands to the Oracle libraries. To get the file to work, you must place it
  somewhere where your Apache server can run it, and you must rename it to have
  a ".php" extension. You must also change the username and password on the
  oci_connect below to be your ORACLE username and password
-->

<?php
// The preceding tag tells the web server to parse the following text as PHP
// rather than HTML (the default)

// The following 3 lines allow PHP errors to be displayed along with the page
// content. Delete or comment out this block when it's no longer needed.
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Set some parameters

// Database access configuration
$config["dbuser"] = "ora_cserra";			// change "cwl" to your own CWL
$config["dbpassword"] = "a31507149";	// change to 'a' + your student number
$config["dbserver"] = "dbhost.students.cs.ubc.ca:1522/stu";
$db_conn = NULL;	// login credentials are used in connectToDB()

$success = true;	// keep track of errors so page redirects only if there are no errors

$show_debug_alert_messages = False; // show which methods are being triggered (see debugAlertMessage())

// The next tag tells the web server to stop parsing the text as PHP. Use the
// pair of tags wherever the content switches to PHP
?>

<html>

<head>
	<title>CPSC 304 Volleyball Database</title>
	<style>
        body {
            background-color: #ffffff;
            font-family: 'Arial', sans-serif;
        }

        h1 {
            color: #1e6091;
			text-align: center;
        }

        h2 {
            color: #1e6091;
        }

        form {
            margin-bottom: 20px;
        }

        input[type="submit"] {
            background-color: #1e6091;
            color: #ffffff;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
        }

        input[type="text"] {
            padding: 8px;
        }

        table {
            border-collapse: collapse;
            width: 100%;
        }

        table, th, td {
            border: 1px solid #1e6091;
        }

        th, td {
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #1e6091;
            color: #ffffff;
        }
		
    </style>
</head>

<body>
	<h1> CPSC 304 Volleyball Database </h1>
	<h1> <img class="volleyball-image" src="https://t4.ftcdn.net/jpg/04/18/08/23/360_F_418082327_vJjeEA2NMyk7Eg8JpdlJsC2LVMBwj7CV.jpg"
              alt="Volleyball Image" width="400" height="400"> </h1>
	<h2>Reset</h2>
	<p>Press the reset button to reset the table. If this is the first time you're running this page, you MUST use reset</p>

	<form method="POST" action="volleyball.php">
		<!-- "action" specifies the file or page that will receive the form data for processing. As with this example, it can be this same file. -->
		<input type="hidden" id="resetTablesRequest" name="resetTablesRequest">
		<p><input type="submit" value="Reset" name="reset"></p>
	</form>

	<hr />


	<!-- JOIN: Members & Players table, search by PlayerID -->
	<h2> Checkout some player stats! </h2>
	<form method="GET" action="volleyball.php">
		<input type="hidden" id="joinRequest" name="joinRequest">
		Player ID: <input type="text" name="playerID"> <br /><br />

		<input type="submit" name="join"></p>
	</form>

	<hr />

	<!-- NESTED AGG W/ GROUP BY: Average sponsorship amount per tournament -->
	<h2> Tournament Showcase: Average Sponsorship Insights </h2>
	<form method="GET" action="volleyball.php">
		<input type="hidden" id="avgSponsorshipRequest" name="avgSponsorshipRequest">
		<input type="submit" name="avgSponsorship"></p>
	</form>

	<hr />


	<!-- PROJECTION -->
	<h2>Search Here!</h2>
	<form method="GET" action="volleyball.php">
		<label for="selectedTable">Select a table:</label>
		<select id="selectedTable" name="selectedTable">
			<?php
			
			// Connect to the db on page reload
			connectToDB();
			$tableNames = fetchTableNames();

			// Display the fetched table names
			foreach ($tableNames as $tableName) {
				echo "<option value=\"$tableName\">$tableName</option>";
			}
			?>
		</select>
		Attributes to search for (comma separated): <input type="text" name="attributeSearch"> <br /><br />
		<br><br>
		<input type="submit" name="displayTableSubmit" value="Search">
	</form>

	<hr />

    <!-- SELECTION: Members from Vancouver-->
    <h2> SELECTION </h2>
    <p>Find the name and birthdate of members residing in</p>
    <form method="GET" action="volleyball.php">
        <input type="hidden" id="selectionRequest" name="selectionRequest">
        city: <input type="text" name="city"> <br /><br />
        <input type="submit" name="selection"></p>
    </form>

    <hr />

    <!-- AGGREGATION W GROUP BY: -->
    <h2> AGGREGATION WITH GROUP BY </h2>
    <p>Find the number of players in each team in our database</p>
    <form method="GET" action="volleyball.php">
        <input type="hidden" id="AggGBRequest" name="AggGBRequest">
        <input type="submit" name="AggGB"></p>
    </form>
    <!-- AGGREGATION W HAVING: -->
    <h2> AGGREGATION WITH HAVING </h2>
    <p>Find the list of organizations with an average sponsorship amount of $200K+ for tournaments</p>
    <form method="GET" action="volleyball.php">
        <input type="hidden" id="AggHRequest" name="AggHRequest">
        <input type="submit" name="AggH"></p>
    </form>
    <hr />

	<h2>Insert Values into DemoTable</h2>
	<form method="POST" action="volleyball.php">
		<input type="hidden" id="insertQueryRequest" name="insertQueryRequest">
		Number: <input type="text" name="insNo" style="margin-right: 10px;">
		Name: <input type="text" name="insName"> <br /><br />

        <input type="submit" value="Insert" name="insertSubmit"></p>
	</form>

	<hr />


	<h2>Update Name in DemoTable</h2>
	<p>The values are case sensitive and if you enter in the wrong case, the update statement will not do anything.</p>

	<form method="POST" action="volleyball.php">
		<input type="hidden" id="updateQueryRequest" name="updateQueryRequest">
		Old Name: <input type="text" name="oldName"> <br /><br />
		New Name: <input type="text" name="newName"> <br /><br />

		<input type="submit" value="Update" name="updateSubmit"></p>
	</form>

	<hr />

	<h2>Count the Tuples in DemoTable</h2>
	<form method="GET" action="volleyball.php">
		<input type="hidden" id="countTupleRequest" name="countTupleRequest">
		<input type="submit" name="countTuples"></p>
	</form>

	<hr />

	<h2>Display Tuples in DemoTable</h2>
	<form method="GET" action="volleyball.php">
		<input type="hidden" id="displayTuplesRequest" name="displayTuplesRequest">
		<input type="submit" name="displayTuples"></p>
	</form>


	<?php
	// The following code will be parsed as PHP

	function debugAlertMessage($message)
	{
		global $show_debug_alert_messages;

		if ($show_debug_alert_messages) {
			echo "<script type='text/javascript'>alert('" . $message . "');</script>";
		}
	}

	function executePlainSQL($cmdstr)
	{ //takes a plain (no bound variables) SQL command and executes it
		//echo "<br>running ".$cmdstr."<br>";
		global $db_conn, $success;

		$statement = oci_parse($db_conn, $cmdstr);
		//There are a set of comments at the end of the file that describe some of the OCI specific functions and how they work

		if (!$statement) {
			echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
			$e = OCI_Error($db_conn); // For oci_parse errors pass the connection handle
			echo htmlentities($e['message']);
			$success = False;
		}

		$r = oci_execute($statement, OCI_DEFAULT);
		if (!$r) {
			echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
			$e = oci_error($statement); // For oci_execute errors pass the statementhandle
			echo htmlentities($e['message']);
			$success = False;
		}

		return $statement;
	}

	function executeBoundSQL($cmdstr, $list)
	{
		/* Sometimes the same statement will be executed several times with different values for the variables involved in the query.
		In this case you don't need to create the statement several times. Bound variables cause a statement to only be
		parsed once and you can reuse the statement. This is also very useful in protecting against SQL injection.
		See the sample code below for how this function is used */

		global $db_conn, $success;
		$statement = oci_parse($db_conn, $cmdstr);

		if (!$statement) {
			echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
			$e = OCI_Error($db_conn);
			echo htmlentities($e['message']);
			$success = False;
		}

		foreach ($list as $tuple) {
			foreach ($tuple as $bind => $val) {
				//echo $val;
				//echo "<br>".$bind."<br>";
				oci_bind_by_name($statement, $bind, $val);
				unset($val); //make sure you do not remove this. Otherwise $val will remain in an array object wrapper which will not be recognized by Oracle as a proper datatype
			}

			$r = oci_execute($statement, OCI_DEFAULT);
			if (!$r) {
				echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
				$e = OCI_Error($statement); // For oci_execute errors, pass the statementhandle
				echo htmlentities($e['message']);
				echo "<br>";
				$success = False;
			}
		}
	}
	
	//prints results from a select statement
	function printResult($result)
	{ 
		echo "<br>Retrieved data from table demoTable:<br>";
		echo "<table>";
		echo "<tr><th>ID</th><th>Name</th></tr>";

		while ($row = OCI_Fetch_Array($result, OCI_ASSOC)) {
			echo "<tr><td>" . $row["ID"] . "</td><td>" . $row["NAME"] . "</td></tr>"; //or just use "echo $row[0]"
		}

		echo "</table>";
	}

	function connectToDB()
	{
		global $db_conn;
		global $config;

		// Your username is ora_(CWL_ID) and the password is a(student number). For example,
		// ora_platypus is the username and a12345678 is the password.
		// $db_conn = oci_connect("ora_cwl", "a12345678", "dbhost.students.cs.ubc.ca:1522/stu");
		$db_conn = oci_connect($config["dbuser"], $config["dbpassword"], $config["dbserver"]);

		if ($db_conn) {
			debugAlertMessage("Database is Connected");
			return true;
		} else {
			debugAlertMessage("Cannot connect to Database");
			$e = OCI_Error(); // For oci_connect errors pass no handle
			echo htmlentities($e['message']);
			return false;
		}
	}

	function disconnectFromDB()
	{
		global $db_conn;

		debugAlertMessage("Disconnect from Database");
		oci_close($db_conn);
	}

	function fetchTableNames()
	{
		global $db_conn;
	
		$query = "SELECT table_name FROM user_tables";
		$result = executePlainSQL($query);
	
		$tableNames = array();
		while ($row = oci_fetch_assoc($result)) {
			$tableNames[] = $row['TABLE_NAME'];
		}
	
		return $tableNames;
	}

	function handleUpdateRequest()
	{
		global $db_conn;

		$old_name = $_POST['oldName'];
		$new_name = $_POST['newName'];

		// you need the wrap the old name and new name values with single quotations
		executePlainSQL("UPDATE demoTable SET name='" . $new_name . "' WHERE name='" . $old_name . "'");
		oci_commit($db_conn);
	}

	function handleResetRequest()
	{
		global $db_conn;
		// Drop old table
		executePlainSQL("DROP TABLE demoTable");

		// Create new table
		echo "<br> creating new table <br>";
		executePlainSQL("CREATE TABLE demoTable (id int PRIMARY KEY, name char(30))");
		oci_commit($db_conn);
	}

	function handleInsertRequest()
	{
		global $db_conn;

		//Getting the values from user and insert data into the table
		$tuple = array(
			":bind1" => $_POST['insNo'],
			":bind2" => $_POST['insName']
		);

		$alltuples = array(
			$tuple
		);

		executeBoundSQL("insert into demoTable values (:bind1, :bind2)", $alltuples);
		oci_commit($db_conn);
	}

	function handleCountRequest()
	{
		global $db_conn;

		$result = executePlainSQL("SELECT Count(*) FROM demoTable");

		if (($row = oci_fetch_row($result)) != false) {
			echo "<br> The number of tuples in demoTable: " . $row[0] . "<br>";
		}
	}

	function handleDisplayRequest()
	{
		global $db_conn;
		$result = executePlainSQL("SELECT * FROM demoTable");
		printResult($result);
	}

	function handleJoinRequest()
	{

		global $db_conn;
        connectToDB();
		$playerID = $_GET['playerID'];

		// Validate that the input is a numeric value
		if (!is_numeric($playerID)) {
			echo "Error: PlayerID must be a numeric value.";
			return;
		}

		$sql = "SELECT P.ID, P.JerseyNum, P.Position, P.TeamID, PS.StatID, PS.MatchesPlayed, PS.GamesWon, PS.NumofPoints
				FROM Players P, PlayerStats PS
				WHERE P.ID = PS.PlayerID
					AND P.ID = '" . $_GET['playerID'] . "'";



		$result = executePlainSQL($sql);

		echo "<br>Retrieved data from the join query:<br>";
		echo "<table border='1'>";
		echo "<tr><th>ID</th><th>JerseyNum</th><th>Position</th><th>TeamID</th><th>StatID</th><th>MatchesPlayed</th><th>GamesWon</th><th>NumofPoints</th></tr>";
		
		while ($row = OCI_fetch_array($result, OCI_NUM)) {

			if ($row === false) {
				$e = oci_error($result);
				echo "Error fetching data: " . htmlentities($e['message']);
				break;
			}

			echo "<tr>";
			echo "<td>" . $row[0] . "</td>";
			echo "<td>" . $row[1] . "</td>";
			echo "<td>" . $row[2] . "</td>";
			echo "<td>" . $row[3] . "</td>";
			echo "<td>" . $row[4] . "</td>";
			echo "<td>" . $row[5] . "</td>";
			echo "<td>" . $row[6] . "</td>";
			echo "<td>" . $row[7] . "</td>";
			echo "</tr>";
		}
		echo "</table>";
	}

	function handleAvgSponsorshipRequest() {
		global $db_conn;
	
		$sql = "SELECT t.Name AS TournamentName, AVG(ts.AmountSponsored) AS AvgSponsorship FROM 
					(SELECT s.TournamentID, o.AmountSponsored 
					FROM Sponsors s 
					JOIN Organization o 
					ON s.OrganizationID = o.OrganizationID) ts JOIN Tournament t ON ts.TournamentID = t.TournamentID GROUP BY t.Name, t.TournamentID ORDER BY t.TournamentID";
	
	
		$result = executePlainSQL($sql);
		if (!$result) {
			$e = OCI_Error($db_conn);
			echo "Error executing query: " . htmlentities($e['message']);
		}
		else {
		echo "<br>Tournaments & Average Sponsorships:<br>";
		echo "<table border='1'>";
		echo "<tr><th>Tournament</th><th>Average Sponsorship Amount Received</th></tr>";

		while ($row = OCI_fetch_array($result, OCI_NUM)) {
			echo "<tr>";
			echo "<td>" . $row[0] . "</td>";
			echo "<td>$" . $row[1] . "</td>";
			echo "</tr>";
		}
		echo "</table>";
		}
	}


	function handleSearchRequest() {
		global $db_conn;

		// Retrieve user input
		$tableName = $_GET['selectedTable'];
		$attributeSearchList = $_GET['attributeSearch'];

		// Validate input format (numerical values separated by commas)
		if (!preg_match('/^(\d+,)*\d+$/', $attributeSearchList)) {
			echo "Error: Invalid input format. Please enter numerical values separated by commas.";
			return;
		}


		$columnNumbers = explode(',', $attributeSearchList);
	
		// Query to get all column names of the selected table
		$sqlTemplate = "SELECT column_name FROM USER_TAB_COLUMNS WHERE table_name = '$tableName'";
		$result = executePlainSQL($sqlTemplate);
	
		// Declare an empty array to store db fetched column names
		$allColumnNames = array();
		while ($row = OCI_fetch_array($result, OCI_BOTH)) {
			$allColumnNames[] = $row[0];
		}

		// Error handling for out of bounds column
		foreach($columnNumbers as $columnNumber) {
			if ($columnNumber > (count($allColumnNames) - 1)) {
				echo "Error: Invalid input format. Please enter numerical values separated by commas.";
				return;
			}
		}

		// Filtered column names based on user input
		$filteredColumnNames = array();
		foreach ($columnNumbers as $columnNumber) {
			if (isset($allColumnNames[$columnNumber])) {
				$filteredColumnNames[] = $allColumnNames[$columnNumber];
			}
		}
	
		// Construct the SQL query with the selected columns
		$selectedColumns = implode(', ', $filteredColumnNames);
		$sql = "SELECT $selectedColumns FROM $tableName";
	
		// Execute the query
		$result = executePlainSQL($sql);
	
		echo "<br>Search results from $tableName with Selected Columns:<br>";
		echo "<table border='1'>";
		echo "<tr>";


		// Display column headers
		foreach ($filteredColumnNames as $filteredColumnName) {
			echo "<th>$filteredColumnName</th>";
		}
		echo "</tr>";
	

		// Display query results
		while ($row = OCI_fetch_array($result, OCI_BOTH)) {
			echo "<tr>";
			for ($i = 0; $i < sizeof($filteredColumnNames); $i++) {
				if (isset($row[$i])) {
					echo "<td>" . $row[$i] . "</td>";
				}
				else {
					echo "<td>Not available</td>";
				}
			}
			echo "</tr>";
		}
	
		echo "</table>";
	}

    function handleSelectionRequest()
    {
        global $db_conn;

        $city = $_GET['city'];
        if (!preg_match('/^[a-zA-Z]+$/', $city)) {
            echo "ERROR: Invalid input format. Please enter a valid city name.";
            return;
        }

        $sql = "SELECT Name, BirthDate
        FROM Members
        WHERE UPPER(City) = UPPER('" . $city . "')";
        $result = executePlainSQL($sql);

        echo "<br>Retrieved data from SELECTION query:<br>";
        if(oci_fetch_assoc($result)===false) {
            echo "No results for the specified city";
            return;
        }
        echo "<table border='1'>";
        echo "<tr>
              <th>Name</th>
              <th>BirthDate</th>
              </tr>";

        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            echo "<tr>";
            echo "<td>" . $row[0] . "</td>";
            echo "<td>" . $row[1] . "</td>";
            echo "</tr>";
        }
        echo "</table>";
    }

    function handleAggregation_GBRequest()
    {
        global $db_conn;

        $sql = "SELECT TeamID, COUNT(*) AS NumPlayers 
                FROM Players 
                GROUP BY TeamID";
        $result = executePlainSQL($sql);

        echo "<br>Retrieved data from AGGREGATION (GB) query:<br>";
        echo "<table border='1'>";
        echo "<tr>
              <th>TeamID</th>
              <th>NumPlayers</th>
              </tr>";

        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            echo "<tr>";
            echo "<td>" . $row[0] . "</td>";
            echo "<td>" . $row[1] . "</td>";
            echo "</tr>";
        }
        echo "</table>";
    }

    function handleAggregation_HRequest()
    {
        global $db_conn;

        $sql = "SELECT o.OrganizationID, o.Name, AVG(s.AmountSponsored) AS AverageSponsorship
                FROM Organization o
                JOIN Sponsors s ON o.OrganizationID = s.OrganizationID
                GROUP BY o.OrganizationID, o.Name
                HAVING AVG(s.AmountSponsored) > 200000";
        $result = executePlainSQL($sql);

        echo "<br>Retrieved data from AGGREGATION (H) query:<br>";
        echo "<table border='1'>";
        echo "<tr>
              <th>OrganizationID</th>
              <th>Name</th>
              <th>AverageSponsorship</th>
              </tr>";

        while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
            echo "<tr>";
            echo "<td>" . $row[0] . "</td>";
            echo "<td>" . $row[1] . "</td>";
            echo "<td>" . $row[2] . "</td>";
            echo "</tr>";
        }
        echo "</table>";
    }

	// HANDLE ALL POST ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
	function handlePOSTRequest()
	{
		if (connectToDB()) {
			if (array_key_exists('resetTablesRequest', $_POST)) {
				handleResetRequest();
			} else if (array_key_exists('updateQueryRequest', $_POST)) {
				handleUpdateRequest();
			} else if (array_key_exists('insertQueryRequest', $_POST)) {
				handleInsertRequest();
			}

			disconnectFromDB();
		}
	}

	// HANDLE ALL GET ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
	function handleGETRequest()
	{
		if (connectToDB()) {
			if (array_key_exists('countTuples', $_GET)) {
				handleCountRequest();
			} elseif (array_key_exists('displayTuples', $_GET)) {
				handleDisplayRequest();
			} elseif (array_key_exists('join', $_GET)) {
				handleJoinRequest();
			} elseif (array_key_exists('avgSponsorship', $_GET)) {
				handleAvgSponsorshipRequest();
			} elseif (array_key_exists('displayTableSubmit', $_GET)) {
				handleSearchRequest();
			} elseif (array_key_exists('selection', $_GET)) {
                handleSelectionRequest();
            } elseif (array_key_exists('AggGB', $_GET)) {
                handleAggregation_GBRequest();
            } elseif (array_key_exists('AggH', $_GET)) {
                handleAggregation_HRequest();
            }

			disconnectFromDB();
		}
	}

	if (isset($_POST['reset']) || isset($_POST['updateSubmit']) || isset($_POST['insertSubmit'])) {
		handlePOSTRequest();
	} else if (isset($_GET['countTupleRequest']) || isset($_GET['displayTuplesRequest']) || isset($_GET['joinRequest']) || isset($_GET['avgSponsorshipRequest']) 
			|| (isset($_GET['selectedTable']) && isset($_GET['attributeSearch'])) || isset($_GET['selectionRequest']) || (isset($_GET['AggGBRequest']) || isset($_GET['AggHRequest']) )) {
		handleGETRequest();
    }

	// End PHP parsing and send the rest of the HTML content
	?>
</body>

</html>