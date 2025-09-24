terraform {

  required_providers {

    kubernetes = {

      source  = "hashicorp/kubernetes"

      version = "~> 2.32"

    }

  }

}



provider "kubernetes" {

  config_path = "~/.kube/config"

}



variable "project" {

  default = "github-ansible"

}



variable "app" {

  default = "gitansibletf"

}



variable "image" {

  default = "nginxinc/nginx-unprivileged:stable"

}



resource "kubernetes_namespace_v1" "ns" {

  metadata {

    name = var.project

  }

}



resource "kubernetes_deployment_v1" "deploy" {

  metadata {

    name      = var.app

    namespace = var.project

    labels = {

      app = var.app

    }

  }



  spec {

    replicas = 1



    selector {

      match_labels = {

        app = var.app

      }

    }



    template {

      metadata {

        labels = {

          app = var.app

        }

      }



      spec {

        container {

          name  = var.app

          image = var.image



          port {

            container_port = 8080

          }

        }

      }

    }

  }

}



resource "kubernetes_service_v1" "svc" {

  metadata {

    name      = var.app

    namespace = var.project

  }



  spec {

    selector = {

      app = var.app

    }



    port {

      port        = 8080

      target_port = 8080

    }



    type = "ClusterIP"

  }

}


