import java.time.ZoneId;
import java.time.zone.ZoneRulesProvider;

public class TZDBVersion {
    public static void main (String[] args) {
        String currentZoneId = ZoneId.systemDefault().getId();
        String tzdbVersion = ZoneRulesProvider.getVersions(currentZoneId).firstEntry().getKey();

        System.err.printf("ZoneId: [%s]. TZDB Version: [%s]\n", currentZoneId, tzdbVersion);
    }
}
