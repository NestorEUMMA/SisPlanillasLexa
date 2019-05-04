<?php

use yii\helpers\Html;
use yii\grid\GridView;


// VALIDACION DE SESION Y CONEXION
include '../include/dbconnect.php';
if(!isset($_SESSION))
    {
        session_start();
    }
 $urlperreport = '../aguinaldos/report';
 $urlperupdate = '../aguinaldos/update';
 $urlperview = '../aguinaldos/view';
 $urlpercreate = '../aguinaldos/create';
 $urlperdelete = '../aguinaldos/delete';
 $usuario = $_SESSION['user'];


// ************************************************************************
$permisosreport = "select  menudetalle.DescripcionMenuDetalle as 'DETALLE', menuusuario.MenuUsuarioActivo as 'ACTIVO', menudetalle.Url as 'URL' from menuusuario
        inner join MenuDetalle on menuusuario.IdMenuDetalle = menudetalle.IdMenuDetalle
        inner join menu on menuusuario.IdMenu = menu.IdMenu
        inner join usuario on menuusuario.IdUsuario = usuario.IdUsuario
        where usuario.InicioSesion = '" . $usuario . "' and TipoPermiso = 2 and menudetalle.Url = '" . $urlperreport . "'";

$resultadopermisosreport = $mysqli->query($permisosreport);

while ($resreport = $resultadopermisosreport->fetch_assoc())
           {
               $urlreport = $resreport['URL'];
               $activoreport = $resreport['ACTIVO'];
           }

if($urlperreport == $urlreport and $activoreport == 1){
    $report = '{report}';
}
else{
  $report = '';
}


// VALIDACION DE PERMISOS UPDATE
    $permisosupdate = "select  menudetalle.DescripcionMenuDetalle as 'DETALLE', menuusuario.MenuUsuarioActivo as 'ACTIVO', menudetalle.Url as 'URL' from menuusuario
            inner join MenuDetalle on menuusuario.IdMenuDetalle = menudetalle.IdMenuDetalle
            inner join menu on menuusuario.IdMenu = menu.IdMenu
            inner join usuario on menuusuario.IdUsuario = usuario.IdUsuario
            where usuario.InicioSesion = '" . $usuario . "' and TipoPermiso = 2 and menudetalle.Url = '" . $urlperupdate . "'";

    $resultadopermisosupdate = $mysqli->query($permisosupdate);

    while ($resupdate = $resultadopermisosupdate->fetch_assoc())
               {
                   $urlupdate = $resupdate['URL'];
                   $activoupdate = $resupdate['ACTIVO'];
               }

    if($urlperupdate == $urlupdate and $activoupdate == 1){
        $update = '{update}';
    }
    else{
      $update = '';
    }

// VALIDACION DE PERMISOS VIEW
    $permisosview = "select  menudetalle.DescripcionMenuDetalle as 'DETALLE', menuusuario.MenuUsuarioActivo as 'ACTIVO', menudetalle.Url as 'URL' from menuusuario
            inner join MenuDetalle on menuusuario.IdMenuDetalle = menudetalle.IdMenuDetalle
            inner join menu on menuusuario.IdMenu = menu.IdMenu
            inner join usuario on menuusuario.IdUsuario = usuario.IdUsuario
            where usuario.InicioSesion = '" . $usuario . "' and TipoPermiso = 2 and menudetalle.Url = '" . $urlperview . "'";

    $resultadopermisosview = $mysqli->query($permisosview);

    while ($resview = $resultadopermisosview->fetch_assoc())
               {
                   $urlview = $resview['URL'];
                   $activoview = $resview['ACTIVO'];
               }

    if($urlperview == $urlview and $activoview == 1){
        $view = '{view}';
    }
    else{
      $view = '';
    }



// VALIDACION DE PERMISOS CREATE
    $permisoscreate = "select  menudetalle.DescripcionMenuDetalle as 'DETALLE', menuusuario.MenuUsuarioActivo as 'ACTIVO', menudetalle.Url as 'URL' from menuusuario
            inner join MenuDetalle on menuusuario.IdMenuDetalle = menudetalle.IdMenuDetalle
            inner join menu on menuusuario.IdMenu = menu.IdMenu
            inner join usuario on menuusuario.IdUsuario = usuario.IdUsuario
            where usuario.InicioSesion = '" . $usuario . "' and TipoPermiso = 2 and menudetalle.Url = '" . $urlpercreate . "'";

    $resultadopermisoscreate = $mysqli->query($permisoscreate);

    while ($rescreate = $resultadopermisoscreate->fetch_assoc())
               {
                   $urlcreate = $rescreate['URL'];
                   $activocreate = $rescreate['ACTIVO'];
               }



 // VALIDACION DE PERMISOS DELETE
     $permisosdelete = "select  menudetalle.DescripcionMenuDetalle as 'DETALLE', menuusuario.MenuUsuarioActivo as 'ACTIVO', menudetalle.Url as 'URL' from menuusuario
             inner join MenuDetalle on menuusuario.IdMenuDetalle = menudetalle.IdMenuDetalle
             inner join menu on menuusuario.IdMenu = menu.IdMenu
             inner join usuario on menuusuario.IdUsuario = usuario.IdUsuario
             where usuario.InicioSesion = '" . $usuario . "' and TipoPermiso = 2 and menudetalle.Url = '" . $urlperdelete . "'";

     $resultadopermisosdelete = $mysqli->query($permisosdelete);

     while ($resdelete = $resultadopermisosdelete->fetch_assoc())
                {
                    $urldelete = $resdelete['URL'];
                    $activodelete = $resdelete['ACTIVO'];
                }

      if($urlperdelete == $urldelete and $activodelete == 1){
          $delete = '{delete}';
      }
      else{
        $delete = '';
      }



/* @var $this yii\web\View */
/* @var $searchModel app\models\Aguinaldossearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

$this->title = 'Aguinaldos';
$this->params['breadcrumbs'][] = $this->title;

      $queryempleado = "select IdEmpleado, CONCAT(PrimerNomEmpleado,' ',SegunNomEmpleado,' ',PrimerApellEmpleado,' ',SegunApellEmpleado)  AS NombreCompleto from empleado where EmpleadoActivo = 1 order by NombreCompleto asc";
      $resultadoqueryempleado = $mysqli->query($queryempleado);
?>

<div align="right">
    <?php
        if($urlpercreate == $urlcreate and $activocreate == 1){
          ?>
          <button class="btn btn-success btn-raised " data-toggle="modal" data-target="#myModal">
                                         Nueva Aguinaldo
         </button>
            <?php
        }
        else{
          $create = '';
        }
      ?>
</div>

    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header card-header-icon" data-background-color="orange">
                    <i class="material-icons">assignment</i>
                </div>
                <div class="card-content">
                  <h4 class="card-title"><?= Html::encode($this->title) ?></h4>
                  <div class="toolbar">
                    </div>
                    <div class="table-responsive">
                        <table class="table">

                        <?php  echo $this->render('_search', ['model' => $searchModel]); ?>

                            <p>

                            </p>

                            <?= GridView::widget([
                                'dataProvider' => $dataProvider,
                                //'filterModel' => $searchModel,
                                 'columns' => [
                                    ['class' => 'yii\grid\SerialColumn'],

                                    //'IdAguinaldo',
                                   [
                                      'attribute'=>'IdEmpleado',
                                      'value'=>'idEmpleado.fullname',
                                    ],
                                    'PeridoAguinaldo',
                                    'FechaAguinaldo',
                                   [
                                       'attribute' => 'MontoAguinaldo',
                                       'value' => function ($model) {
                                           return '$' . ' ' . $model->MontoAguinaldo;
                                       }
                                    ] ,
                                    ['class' => 'yii\grid\ActionColumn', 'options' => ['style' => 'width:155px;'], 'template' => " $view $update $delete $report"],
                                ],
                            ]); ?>
                      </table>
                    </div>
                </div>
                <!-- end content-->
            </div>
            <!--  end card  -->
        </div>
        <!-- end col-md-12 -->
    </div>

                      <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                      <form action="../../views/aguinaldos/aguinaldoguardar.php" role="form" method="POST">
                                                        <div class="modal-header">
                                                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                                            <h4 class="modal-title">Calculo de Aguinaldo</h4>

                                                        </div>
                                                        <div class="modal-body">
                                                        <div class="form-group">
                                                          <label for="title">Seleccione un Empleado:</label>
                                                          <select name="Empleado" class="form-control">
                                                              <option value="">--- Seleccione un Empleado ---</option>
                                                              <?php
                                                                  while($row = $resultadoqueryempleado->fetch_assoc()){
                                                                      echo "<option value='".$row['IdEmpleado']."'>".$row['NombreCompleto']."</option>";
                                                                  }
                                                              ?>
                                                          </select>
                                                         </div>
                                                          <div class="modal-footer">
                                                              <button type="button" class="btn btn-danger" data-dismiss="modal">Cerrar</button>
                                                              <button type="submit" class="btn btn-success" name="guardarHonorario" >Calcular Aguinaldo</button>
                                                        </div>
                                                      </form>
                                                    </div>
                                                </div>
                                        </div>
<script src="../../assets/js/jquery-3.2.1.min.js" type="text/javascript"></script>
<script type="text/javascript">
    $(document).ready(function(){

        demo.initFormExtendedDatetimepickers();

    });
</script>

<script>
  $(function() {
    $('#currency').maskMoney();
  })
</script>
