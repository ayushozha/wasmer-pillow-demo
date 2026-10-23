const path=require('path');const wd=process.argv[2];
const cfg=require(path.join(wd,'webpack.config.js'));const CMP=require(path.join(wd,'node_modules/css-minimizer-webpack-plugin'));
cfg.mode='production';cfg.optimization.minimizer=[new CMP({parallel:false})];
require(path.join(wd,'node_modules/webpack'))(cfg,(e,s)=>{if(e){console.log('ERR',e);return}console.log(s.toString({all:false,errors:true,warnings:false}).slice(0,1500))});
