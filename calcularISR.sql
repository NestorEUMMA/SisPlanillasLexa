SELECT 
	E.SalarioNominal AS 'SALARIO NOMINAL',

    CASE /* CALCULA EL AFP Y VALIDA SI ES MAYOR AL TECHO */
		WHEN E.SalarioNominal <= (SELECT TechoAfp FROM tramoafp WHERE IdTramoAfp = 1) THEN CONVERT((E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)), DECIMAL(10,2))
		WHEN E.SalarioNominal >= (SELECT TechoAfpSig FROM tramoafp WHERE IdTramoAfp = 1) THEN CONVERT(((SELECT TechoAfp FROM tramoafp WHERE IdTramoAfp = 1) * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)), DECIMAL(10,2))
	END AS 'AFP',
    
    CASE /* CALCULA EL ISSS Y VALIDA SI ES MAYOR AL TECHO */
		WHEN E.SalarioNominal <= (SELECT TechoIsss FROM tramoisss WHERE IdTramoIsss = 1) THEN CONVERT((E.SalarioNominal * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1)), DECIMAL(10,2))
        WHEN E.SalarioNominal >= (SELECT TechoSig FROM tramoisss WHERE IdTramoIsss = 1) THEN CONVERT(((SELECT TechoIsss FROM tramoisss WHERE IdTramoIsss = 1) * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1)), DECIMAL(10,2))
	END AS 'ISSS',
    
        /*CALCULA EL ISR Y VALIDA LOS TRAMOS, TECHOS DE AFP E ISSS */
	CASE	/* TRAMO 1 */		 
		WHEN CONVERT(E.SalarioNominal - ((E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)) + (E.SalarioNominal * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1))), DECIMAL(10,2)) 
        >= (SELECT TramoDesde FROM tramoisr WHERE NumTramo = 'Tramo 1' AND TramoFormaPago = 'MENSUAL') 
				AND CONVERT(E.SalarioNominal - ((E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)) + (E.SalarioNominal * 0.03)), DECIMAL(10,2)) <= 
                (SELECT TramoHasta FROM tramoisr WHERE NumTramo = 'Tramo 1' AND TramoFormaPago = 'MENSUAL') 
			THEN CONVERT((E.SalarioNominal * 0.00), DECIMAL(10,2))
            
			/* TRAMO 2 */
        WHEN CONVERT(E.SalarioNominal - ((E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)) + (E.SalarioNominal * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1))), DECIMAL(10,2)) >= 
				(SELECT TramoDesde FROM tramoisr WHERE NumTramo = 'Tramo 2' AND TramoFormaPago = 'MENSUAL') 
				AND CONVERT(E.SalarioNominal - ((E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)) + (E.SalarioNominal * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1))), DECIMAL(10,2)) <= 
                (SELECT TramoHasta FROM tramoisr WHERE NumTramo = 'Tramo 2' AND TramoFormaPago = 'MENSUAL') 
			THEN CONVERT((((E.SalarioNominal - (E.SalarioNominal * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1)) 
				- (E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)) 
                - (SELECT TramoExceso FROM tramoisr WHERE NumTramo = 'Tramo 2' AND TramoFormaPago = 'MENSUAL')) 
                * (SELECT TramoAplicarPorcen FROM tramoisr WHERE NumTramo = 'Tramo 2' AND TramoFormaPago = 'MENSUAL')) 
                + (SELECT TramoCuota FROM tramoisr WHERE NumTramo = 'Tramo 2' AND TramoFormaPago = 'MENSUAL')), DECIMAL(10,2))
			
			/* TRAMO 3 */
		WHEN CONVERT( E.SalarioNominal - ((E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)) + (E.SalarioNominal * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1))), DECIMAL(10,2)) >= 
			(SELECT TramoDesde FROM tramoisr WHERE NumTramo = 'Tramo 3' AND TramoFormaPago = 'MENSUAL') 
				AND E.SalarioNominal <= (SELECT TechoIsss FROM tramoisss WHERE IdTramoIsss = 1)
			THEN 
            CASE
				WHEN CONVERT(E.SalarioNominal - ((E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)) + (E.SalarioNominal * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1))), DECIMAL(10,2)) >= 
					(SELECT TramoDesde FROM tramoisr WHERE NumTramo = 'Tramo 3' AND TramoFormaPago = 'MENSUAL') 
					AND CONVERT(E.SalarioNominal - ((E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)) + (E.SalarioNominal * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1))), DECIMAL(10,2)) <= 
					(SELECT TramoHasta FROM tramoisr WHERE NumTramo = 'Tramo 3' AND TramoFormaPago = 'MENSUAL') 
				THEN CONVERT((((E.SalarioNominal - (E.SalarioNominal * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1)) 
					- (E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)) 
					- (SELECT TramoExceso FROM tramoisr WHERE NumTramo = 'Tramo 3' AND TramoFormaPago = 'MENSUAL')) 
					* (SELECT TramoAplicarPorcen FROM tramoisr WHERE NumTramo = 'Tramo 3' AND TramoFormaPago = 'MENSUAL')) 
					+ (SELECT TramoCuota FROM tramoisr WHERE NumTramo = 'Tramo 3' AND TramoFormaPago = 'MENSUAL')), DECIMAL(10,2)) 
                END
		WHEN E.SalarioNominal >= (SELECT TechoSig FROM tramoisss WHERE IdTramoIsss = 1) AND CONVERT(E.SalarioNominal - 
                ((E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)) + ((SELECT TechoIsss FROM tramoisss WHERE IdTramoIsss = 1) * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1))), DECIMAL(10,2)) <= 
                (SELECT TramoHasta FROM tramoisr WHERE NumTramo = 'Tramo 3' AND TramoFormaPago = 'MENSUAL') 
                THEN CONVERT((((E.SalarioNominal - ((SELECT TechoIsss FROM tramoisss WHERE IdTramoIsss = 1) * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1)) 
					- (E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)) 
					- (SELECT TramoExceso FROM tramoisr WHERE NumTramo = 'Tramo 3' AND TramoFormaPago = 'MENSUAL')) 
					* (SELECT TramoAplicarPorcen FROM tramoisr WHERE NumTramo = 'Tramo 3' AND TramoFormaPago = 'MENSUAL')) 
					+ (SELECT TramoCuota FROM tramoisr WHERE NumTramo = 'Tramo 3' AND TramoFormaPago = 'MENSUAL')), DECIMAL(10,2))
                    
			/* TRAMO 4 */
		WHEN CONVERT(E.SalarioNominal - ((E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)) + ((SELECT TechoIsss FROM tramoisss WHERE IdTramoIsss = 1) * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1))), DECIMAL(10,2)) >= 
				(SELECT TramoDesde FROM tramoisr WHERE NumTramo = 'Tramo 4' AND TramoFormaPago = 'MENSUAL') 
				AND E.SalarioNominal <=  (SELECT TechoAfp FROM tramoafp WHERE IdTramoAfp = 1)
                 THEN CONVERT((((E.SalarioNominal - ((SELECT TechoIsss FROM tramoisss WHERE IdTramoIsss = 1) * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1)) 
					- (E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)) 
					- (SELECT TramoExceso FROM tramoisr WHERE NumTramo = 'Tramo 4' AND TramoFormaPago = 'MENSUAL')) 
					* (SELECT TramoAplicarPorcen FROM tramoisr WHERE NumTramo = 'Tramo 4' AND TramoFormaPago = 'MENSUAL')) 
					+ (SELECT TramoCuota FROM tramoisr WHERE NumTramo = 'Tramo 4' AND TramoFormaPago = 'MENSUAL')), DECIMAL(10,2))
                    
		WHEN E.SalarioNominal > (SELECT TechoAfpSig FROM tramoafp WHERE IdTramoAfp = 1)
                 THEN CONVERT((((E.SalarioNominal - ((SELECT TechoIsss FROM tramoisss WHERE IdTramoIsss = 1) * (SELECT TramoIsss FROM tramoisss WHERE IdTramoIsss = 1)) 
					- (E.SalarioNominal * (SELECT TramoAfp FROM tramoafp WHERE IdTramoAfp = 1)) 
					- (SELECT TramoExceso FROM tramoisr WHERE NumTramo = 'Tramo 4' AND TramoFormaPago = 'MENSUAL')) 
					* (SELECT TramoAplicarPorcen FROM tramoisr WHERE NumTramo = 'Tramo 4' AND TramoFormaPago = 'MENSUAL')) 
					+ (SELECT TramoCuota FROM tramoisr WHERE NumTramo = 'Tramo 4' AND TramoFormaPago = 'MENSUAL')), DECIMAL(10,2))
            
	END AS 'ISR',
    
	(E.SalarioNominal) as 'SALARIO NETO'

FROM empleado E 	
LEFT JOIN deduccionempleado DE on E.IdEmpleado = DE.IdEmpleado
WHERE E.IdEmpleado = 3