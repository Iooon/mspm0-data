use crate::util::RegexMap;

pub static PERIMAP: RegexMap<(&str, &str)> = RegexMap::new(&[
    (".*:uart", ("uart", "v1")),
    (".*:gpio", ("gpio", "v1")),
    (".*:dma", ("dma", "v1")),
    (".*:i2c", ("i2c", "v1")),
    (".*:beeper", ("beeper", "v1")),
    (".*:cpuss", ("cpuss", "v1")),
    (".*:iomux", ("iomux", "v1")),
    (".*:tim", ("tim", "v1")),
    ("MSPM0C110X:sysctl", ("sysctl", "v1")),
    ("MSPM0L110X:sysctl", ("sysctl", "v2")),
    ("MSPM0L130X:sysctl", ("sysctl", "v2")),
    ("MSPM0L134X:sysctl", ("sysctl", "v2")),
    ("MSPM0L122X:sysctl", ("sysctl", "v3")),
    ("MSPM0L222X:sysctl", ("sysctl", "v3")),
    ("MSPM0G350X:sysctl", ("sysctl", "v4")),
    ("MSPM0G310X:sysctl", ("sysctl", "v4")),
    ("MSPM0G150X:sysctl", ("sysctl", "v4")),
    ("MSPM0G110X:sysctl", ("sysctl", "v4")),
    ("MSPM0G351X:sysctl", ("sysctl", "v5")),
    ("MSPM0G151X:sysctl", ("sysctl", "v5")),
]);
