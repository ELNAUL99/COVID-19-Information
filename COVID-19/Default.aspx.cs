using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using Newtonsoft.Json;

namespace COVID19
{

    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
    }
    [DataContract]
    public class Database
    {
        [JsonProperty(PropertyName = "dateRep")]
        public string DateRep { get; set; }
        [JsonProperty(PropertyName = "cases")]
        public int Cases { get; set; }
        [JsonProperty(PropertyName = "deaths")]
        public int Deaths { get; set; }
        [JsonProperty(PropertyName = "countriesAndTerritories")]
        public string CountriesAndTerritories { get; set; }
        [JsonProperty(PropertyName = "geoId")]
        public string GeoId { get; set; }
        [JsonProperty(PropertyName = "popData2019")]
        public long PopData2019 { get; set; }
        [JsonProperty(PropertyName = "continentExp")]
        public string ContinentExp { get; set; }
    }

    public class OutputInfo
    {
        [JsonProperty(PropertyName = "records")]
        public List<Database> Info { get; set; }

        public List<string> GetAllCountries()
        {
            var list = new List<string>();
            if (Info != null)
            {
                var group = Info.GroupBy(c => c.CountriesAndTerritories);
                foreach (var member in group)
                {
                    list.Add(member.Key);
                }
            }

            return list;
        }

        public Database GetCase(string countryName, string date)
        {
            Database newCases = Info.FirstOrDefault(database => database.CountriesAndTerritories.Equals(countryName) && database.DateRep.Equals(date));
            if (newCases == null)
            {
                return null;
            }

            return newCases;
        }
    }
}
