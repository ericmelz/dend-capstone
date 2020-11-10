---
-- Setup Penal code descriptions for selected charges
---
DROP TABLE IF EXISTS penal_codes;

CREATE TABLE penal_codes (
  code varchar PRIMARY KEY,
  description varchar
);

INSERT INTO penal_codes VALUES ('23152(A)VC', 'driving under the influence of alchohol');
INSERT INTO penal_codes VALUES ('41.27CLAMC', 'drinking alcohol in public');
INSERT INTO penal_codes VALUES ('273.5(A)PC', 'domestic abuse');
INSERT INTO penal_codes VALUES ('11377(A)HS', 'posession of methamphetamine');
INSERT INTO penal_codes VALUES ('11350(A)HS', 'posession of a controlled substance without a prescription');
INSERT INTO penal_codes VALUES ('25620(A)BP', 'posession of an open alcohol container in public');
INSERT INTO penal_codes VALUES ('25620BP', 'posession of an open alcohol container in public');
INSERT INTO penal_codes VALUES ('41.18DLAMC', 'sitting or lying, or sleeping on a public sidewalk');
INSERT INTO penal_codes VALUES ('853.7PC', 'violation of a promise to appear in court');



