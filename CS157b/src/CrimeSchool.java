import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map.Entry;

public class CrimeSchool 
{
	String finalFile = "crimeSchool1213.csv";
	
	private HashMap<String, ArrayList<String>> readCrimeData(String file)
	{
		HashMap<String, ArrayList<String>> crimeData = new HashMap<String, ArrayList<String>>();
		try 
		{
			BufferedReader reader = new BufferedReader(new FileReader(new File(file)));
			String header = reader.readLine();
			String line = "";
			while((line = reader.readLine()) != null)
			{
				int firstcomma = line.indexOf(",");
				String date_time = line.substring(1, firstcomma - 1);
				
				int secondcomma = line.indexOf(",", firstcomma + 1);
				String crime = line.substring(firstcomma + 2, secondcomma - 1);
				
				int thirdcomma = line.indexOf(",", secondcomma + 1);
				double latitude = Double.parseDouble(line.substring(secondcomma + 2, thirdcomma - 1));
				
				int fourthcomma = line.indexOf(",", thirdcomma + 1);
				double longitude = Double.parseDouble(line.substring(thirdcomma + 2, fourthcomma - 1));
				
				int fifthcomma = line.indexOf(",", fourthcomma + 1);
				long caseID = Long.parseLong(line.substring(fourthcomma + 2, fifthcomma - 1));
				
				int sixthcomma = line.indexOf(",", fifthcomma + 1);
				String url = line.substring(fifthcomma + 2, sixthcomma - 1);
				
				String description = line.substring(sixthcomma + 2, line.lastIndexOf('"'));
				
				ArrayList<String> data = new ArrayList<String>();
				data.add(date_time);//0
				data.add(crime);//1
				data.add(latitude + "");//2
				data.add(longitude + "");//3
				data.add(url);//4
				data.add(description);//5
				crimeData.put(caseID + "", data);
			}
			reader.close();
		} 
		catch (FileNotFoundException e) 
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return crimeData;
	}
	
	private HashMap<String, ArrayList<String>> readSchoolData(String file)
	{
		HashMap<String, ArrayList<String>> schoolData = new HashMap<String, ArrayList<String>>();
		try 
		{
			BufferedReader reader = new BufferedReader(new FileReader(new File(file)));
			String header = reader.readLine();
			String line = "";
			while((line = reader.readLine()) != null)
			{
				//System.out.println(line);
				
				int firstcomma = line.indexOf(",");
				long code = Long.parseLong(line.substring(0, firstcomma));
				//System.out.println("code" + code);
				
				int secondcomma = line.indexOf(",", firstcomma + 1);
				String school = line.substring(firstcomma + 1, secondcomma);
				//System.out.println("school" + school);
				
				int thirdcomma = line.indexOf(",", secondcomma + 1);
				String district = line.substring(secondcomma + 1, thirdcomma);
				//System.out.println("district" + district);
				
				int fourthcomma = line.indexOf(",", thirdcomma + 1);
				int api = 0;
				if(line.substring(thirdcomma + 1, fourthcomma).length() != 0)
				{	
					api = Integer.parseInt(line.substring(thirdcomma + 1, fourthcomma));
				}
				//System.out.println("api" + api);
				
				int fifthcomma = line.indexOf(",", fourthcomma + 1);
				int api_old = 0;
				if(line.substring(fourthcomma + 1, fifthcomma).length() != 0)
				{
					api_old = Integer.parseInt(line.substring(fourthcomma + 1, fifthcomma));
				}
				//System.out.println("api_old" + api_old);
				
				int sixthcomma = line.indexOf(",", fifthcomma + 1);
				double latitude = 0;
				if(line.substring(fifthcomma + 1, sixthcomma).length() != 0)
				{
					latitude = Double.parseDouble(line.substring(fifthcomma + 1, sixthcomma));
				}
				//double latitude = Double.parseDouble(line.substring(fifthcomma + 1, sixthcomma));
				//System.out.println("latitude" + latitude);
				
				double longitude = 0;
				if(line.substring(sixthcomma + 1).length() != 0)
				{
					longitude = Double.parseDouble(line.substring(sixthcomma + 1));
				}
				//double longitude = Double.parseDouble(line.substring(sixthcomma + 1));
				//System.out.println("longitude" + longitude);
				
				ArrayList<String> data = new ArrayList<String>();
				data.add(code + "");//0
				data.add(district);//1
				data.add(api + "");//2
				data.add(api_old + "");//3
				data.add(latitude + "");//4
				data.add(longitude + "");//5
				schoolData.put(school, data);
			}
			reader.close();
		} 
		catch (FileNotFoundException e) 
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return schoolData;
	}

	@SuppressWarnings("unchecked")
	public void mapCrimesToSchools(String crimeFile, String schoolFile)
	{
		HashMap<String, ArrayList<String>> crimes = readCrimeData(crimeFile);
		HashMap<String, ArrayList<String>> schools = readSchoolData(schoolFile);
		
		//school name to list of crime codes
		HashMap<String, ArrayList<String>> mapping = new HashMap<String, ArrayList<String>>();
		
		for(Entry<String, ArrayList<String>> s : schools.entrySet())
		{
			for(Entry<String, ArrayList<String>> c : crimes.entrySet())
			{
				//lon1 and lat 1 = school
				//lon2 and lat2 = crime
				double lat1 = Double.parseDouble(s.getValue().get(4));
				double lat2 = Double.parseDouble(c.getValue().get(2));
				double lon1 = Double.parseDouble(s.getValue().get(5));
				double lon2 = Double.parseDouble(c.getValue().get(3));
				double dlon = lon2 - lon1; 
				double dlat = lat2 - lat1; 
				double a = Math.pow((Math.sin(dlat/2)), 2) + Math.cos(lat1) * Math.cos(lat2) * Math.pow((Math.sin(dlon/2)), 2); 
				double x = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a) ) ;
				double d = 3961 * x;
				
				if(d <= 5)
				{
					if(mapping.containsKey(s.getKey()) == true)
					{
						ArrayList<String> list = mapping.remove(s.getKey());
						list.add(c.getKey());
						mapping.put(s.getKey(), list);	
					}
					else
					{
						ArrayList<String> list = new ArrayList<String>();
						list.add(c.getKey());
						mapping.put(s.getKey(), list);
					}
				}
			}
		}
		
		try 
		{
			BufferedWriter writer = new BufferedWriter(new FileWriter(new File(finalFile)));
			writer.write("school,code,district,api,api_old,school_latitude,school_longitude,crime_caseID,date_time,crime,crime_latitude,crime_longitude,url,description");
			writer.newLine();
			for(Entry<String, ArrayList<String>> e : mapping.entrySet())
			{
				String key = e.getKey();
				ArrayList<String> value = e.getValue();
				for(int i = 0; i < value.size(); i++)
				{
					ArrayList<String> s = schools.get(key);
					ArrayList<String> c = crimes.get(value.get(i));
					
					//write school stuff
					writer.write(key + "," + s.get(0) + "," + s.get(1) + "," + s.get(2) + "," + s.get(3) + "," + s.get(4) + "," + s.get(5) + ",");
					
					//write crime stuff
					writer.write(value.get(i) + "," + c.get(0) + "," + c.get(1) + "," + c.get(2) + "," + c.get(3) + "," + c.get(4) + "," + c.get(5));
					
					writer.newLine();
				}	
			}
			writer.close();
		} 
		catch (IOException e) 
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args)
	{
		CrimeSchool cs = new CrimeSchool();
		cs.mapCrimesToSchools("files/crime20122013.csv", "files/schoolapi13.csv");
	}
	
}
