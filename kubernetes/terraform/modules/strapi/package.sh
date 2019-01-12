#!/bin/bash

helm package chart/strapi -d ~/helm-charts/packaged 
helm repo index ~/helm-charts/packaged 
helm repo update 
helm search strapi